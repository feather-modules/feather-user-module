//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreSDK
import CoreSDKInterface
import DatabaseQueryKit
import FeatherComponent
import FeatherValidation
import Logging
import SQLKit
import UserSDKInterface

extension User.Account.Query {

    func roleQueryBuilder() async throws -> User.AccountRole.Query {
        .init(db: db)
    }
}

extension UserSDK {

    private func getQueryBuilder() async throws -> User.Account.Query {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)
    }
}

extension UserSDK {

    private func getAccountBy(
        id: ID<User.Account>
    ) async throws -> User.Account.Detail {
        let queryBuilder = try await getQueryBuilder()

        guard let model = try await queryBuilder.get(id) else {
            throw UserSDKError.unknown
        }

        let roleKeys =
            try await queryBuilder
            .roleQueryBuilder()
            .all(
                .accountId,
                .equal,
                id
            )
            .map { $0.roleKey }
            .map { $0.toID() }

        let roles = try await referenceRoles(keys: roleKeys)
            .map { User.Role.Reference(key: $0.key, name: $0.name) }

        return User.Account.Detail(
            id: model.id.toID(),
            email: model.email,
            roleReferences: roles
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
            throw UserSDKError.unknown
        }

        let roles = try await referenceRoles(keys: roleKeys)
        try await queryBuilder.roleQueryBuilder().delete(.accountId, .equal, id)
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

    public func listAccounts(
        _ input: any UserAccountListQuery
    ) async throws -> any UserAccountList {
        let queryBuilder = try await getQueryBuilder()

        var field: User.Account.Model.FieldKeys
        switch input.sort.by {
        case .email:
            field = .email
        }

        let search = input.search.flatMap { value in
            QueryFilter<User.Account.Model.CodingKeys>(
                field: .email,
                method: .like,
                value: "%\(value)%"
            )
        }

        let result = try await queryBuilder.list(
            .init(
                page: .init(
                    size: input.page.size,
                    index: input.page
                        .index
                ),
                sort: .init(
                    field: field,
                    direction: input.sort.order.queryDirection
                ),
                search: search
            )
        )

        return try User.Account.List(
            items: result.items.map {
                try $0.convert(to: User.Account.List.Item.self)
            },
            query: .init(
                search: input.search,
                sort: .init(by: input.sort.by, order: input.sort.order),
                page: .init(size: input.page.size, index: input.page.index)
            ),
            page: .init(size: input.page.size, index: input.page.index),
            count: UInt(result.total)
        )
    }

    public func referenceAccounts(
        keys: [ID<User.Account>]
    ) async throws -> [UserAccountReference] {
        let queryBuilder = try await getQueryBuilder()

        return try await queryBuilder.all(.id, .in, keys)
            .convert(to: [User.Account.Reference].self)
    }

    public func createAccount(
        _ input: UserAccountCreate
    ) async throws -> UserAccountDetail {
        let queryBuilder = try await getQueryBuilder()

        let input = try input.sanitized()
        let model = User.Account.Model(
            id: .generate(),
            email: input.email,
            password: input.password
        )

        try await queryBuilder.insert(model)
        try await updateAccountRoles(
            input.roleKeys,
            model.id.toID()
        )
        return try await getAccountBy(id: model.id.toID())
    }

    public func getAccount(
        key: ID<User.Account>
    ) async throws -> UserAccountDetail {
        try await getAccountBy(id: key)
    }

    public func updateAccount(
        key: ID<User.Account>,
        _ input: UserAccountUpdate
    ) async throws -> UserAccountDetail {
        let queryBuilder = try await getQueryBuilder()

        guard let oldModel = try await queryBuilder.get(key) else {
            throw UserSDKError.unknown
        }

        let input = try input.sanitized()

        //TODO: validate input
        let newModel = User.Account.Model(
            id: oldModel.id,
            email: input.email,
            password: input.password ?? oldModel.password
        )
        try await queryBuilder.update(key, newModel)
        try await updateAccountRoles(input.roleKeys, key)

        return try await getAccountBy(id: key)
    }

    public func patchAccount(
        key: ID<User.Account>,
        _ input: UserAccountPatch
    ) async throws -> UserAccountDetail {
        let queryBuilder = try await getQueryBuilder()

        guard let oldModel = try await queryBuilder.get(key) else {
            throw UserSDKError.unknown
        }

        let input = try input.sanitized()

        //TODO: validate input
        let newModel = User.Account.Model(
            id: oldModel.id,
            email: input.email ?? oldModel.email,
            password: input.password ?? oldModel.password
        )
        try await queryBuilder.update(key, newModel)
        if let roleKeys = input.roleKeys {
            try await updateAccountRoles(roleKeys, key)
        }

        return try await getAccountBy(id: key)
    }

    public func bulkDeleteAccount(
        keys: [ID<User.Account>]
    ) async throws {
        let queryBuilder = try await getQueryBuilder()
        try await queryBuilder.delete(keys)
    }
}
