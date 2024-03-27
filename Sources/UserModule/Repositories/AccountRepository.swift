//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreModule
import CoreModuleKit
import DatabaseQueryKit
import FeatherComponent
import FeatherValidation
import Logging
import NanoID
import SQLKit
import SystemModuleKit
import UserModuleDatabaseKit
import UserModuleKit

struct AccountRepository: UserAccountInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    // MARK: -

    private func getQueryBuilder() async throws -> User.Account.Query {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)
    }

    private func getAccountBy(
        id: ID<User.Account>
    ) async throws -> User.Account.Detail {
        let queryBuilder = try await getQueryBuilder()

        guard let model = try await queryBuilder.get(id) else {
            throw User.Error.unknown
        }

        let roleKeys =
            try await queryBuilder
            .roleQueryBuilder()
            .all(
                filter: .init(
                    field: .accountId,
                    operator: .equal,
                    value: id
                )
            )
            .map { $0.roleKey }
            .map { $0.toID() }

        let roles = try await user.role.reference(keys: roleKeys)

        return User.Account.Detail(
            id: model.id.toID(),
            email: model.email,
            roles: roles
        )
    }

    private func updateAccountRoles(
        _ roleKeys: [ID<User.Role>],
        _ id: ID<User.Account>
    ) async throws {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        let queryBuilder = User.Account.Query(db: db)
        guard try await queryBuilder.get(id) != nil else {
            throw User.Error.unknown
        }

        let roles = try await user.role.reference(keys: roleKeys)
        try await queryBuilder.roleQueryBuilder()
            .delete(
                filter: .init(
                    field: .accountId,
                    operator: .equal,
                    value: id
                )
            )
        try await queryBuilder.roleQueryBuilder()
            .insert(
                roles.map {
                    User.AccountRole.Model(
                        accountId: id.toKey(),
                        roleKey: $0.key.toKey()
                    )
                }
            )
    }

    // MARK: -

    public func list(
        _ input: User.Account.List.Query
    ) async throws -> User.Account.List {
        let queryBuilder = try await getQueryBuilder()

        var field: User.Account.Model.FieldKeys
        switch input.sort.by {
        case .email:
            field = .email
        }

        let filterGroup = input.search.flatMap { value in
            QueryFilterGroup<User.Account.Model.CodingKeys>(
                relation: .or,
                fields: [
                    .init(
                        field: .email,
                        operator: .like,
                        value: "%\(value)%"
                    )
                ]
            )
        }

        let result = try await queryBuilder.list(
            .init(
                page: .init(
                    size: input.page.size,
                    index: input.page
                        .index
                ),
                orders: [
                    .init(
                        field: field,
                        direction: input.sort.order.queryDirection
                    )
                ],
                filter: filterGroup.map { .init(groups: [$0]) }
            )
        )

        return try .init(
            items: result.items.map {
                try $0.toListItem()
            },
            count: UInt(result.total)
        )
    }

    public func reference(
        ids: [ID<User.Account>]
    ) async throws -> [User.Account.Reference] {
        let queryBuilder = try await getQueryBuilder()

        return
            try await queryBuilder.all(
                filter: .init(
                    field: .id,
                    operator: .in,
                    value: ids
                )
            )
            .map {
                try $0.toReference()
            }
    }

    public func create(
        _ input: User.Account.Create
    ) async throws -> User.Account.Detail {
        let queryBuilder = try await getQueryBuilder()

        let input = try input.sanitized()
        let model = User.Account.Model(
            id: NanoID.generateKey(),
            email: input.email,
            password: input.password
        )

        try await input.validate(queryBuilder)
        try await queryBuilder.insert(model)
        try await updateAccountRoles(
            input.roleKeys,
            model.id.toID()
        )
        return try await getAccountBy(id: model.id.toID())
    }

    public func get(
        id: ID<User.Account>
    ) async throws -> User.Account.Detail {
        try await getAccountBy(id: id)
    }

    public func update(
        id: ID<User.Account>,
        _ input: User.Account.Update
    ) async throws -> User.Account.Detail {
        let queryBuilder = try await getQueryBuilder()

        guard let oldModel = try await queryBuilder.get(id) else {
            throw User.Error.unknown
        }

        let input = try input.sanitized()

        try await input.validate(oldModel.email, queryBuilder)
        let newModel = User.Account.Model(
            id: oldModel.id,
            email: input.email,
            password: input.password ?? oldModel.password
        )
        try await queryBuilder.update(id, newModel)
        try await updateAccountRoles(input.roleKeys, id)

        return try await getAccountBy(id: id)
    }

    public func patch(
        id: ID<User.Account>,
        _ input: User.Account.Patch
    ) async throws -> User.Account.Detail {
        let queryBuilder = try await getQueryBuilder()

        guard let oldModel = try await queryBuilder.get(id) else {
            throw User.Error.unknown
        }

        let input = try input.sanitized()

        try await input.validate(oldModel.email, queryBuilder)
        let newModel = User.Account.Model(
            id: oldModel.id,
            email: input.email ?? oldModel.email,
            password: input.password ?? oldModel.password
        )
        try await queryBuilder.update(id, newModel)
        if let roleKeys = input.roleKeys {
            try await updateAccountRoles(roleKeys, id)
        }

        return try await getAccountBy(id: id)
    }

    public func bulkDelete(
        ids: [ID<User.Account>]
    ) async throws {
        let queryBuilder = try await getQueryBuilder()
        try await queryBuilder.delete(
            filter: .init(
                field: .id,
                operator: .in,
                value: ids
            )
        )
    }
}
