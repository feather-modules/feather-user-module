//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import DatabaseQueryKit
import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import Logging
import SystemModuleKit
import UserModuleKit

struct RoleRepository: UserRoleInterface {

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

    private func getQueryBuilder() async throws -> User.Role.Query {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)
    }

    private func getRoleBy(
        id: ID<User.Role>
    ) async throws -> User.Role.Detail {
        let queryBuilder = try await getQueryBuilder()

        let model = try await queryBuilder.require(id)

        let permissionKeys =
            try await queryBuilder
            .permissionQueryBuilder()
            .all(
                filter: .init(
                    field: .roleKey,
                    operator: .equal,
                    value: id
                )
            )
            .map { $0.permissionKey }
            .map { $0.toID() }

        let permissions = try await user.system.permission
            .reference(
                keys: permissionKeys
            )
            .map { System.Permission.Reference(key: $0.key, name: $0.name) }

        return User.Role.Detail(
            key: model.key.toID(),
            name: model.name,
            notes: model.notes,
            permissions: permissions
        )
    }

    private func updateRolePermissions(
        _ permissionKeys: [ID<System.Permission>],
        _ role: ID<User.Role>
    ) async throws {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        let queryBuilder = User.Role.Query(db: db)
        let roleObj = try await queryBuilder.require(role)

        let permissions = try await user.system.permission.reference(
            keys: permissionKeys
        )
        try await queryBuilder.permissionQueryBuilder()
            .delete(
                filter: .init(
                    field: .roleKey,
                    operator: .equal,
                    value: roleObj.key
                )
            )
        try await queryBuilder.permissionQueryBuilder()
            .insert(
                permissions.map {
                    User.RolePermission.Model(
                        roleKey: roleObj.key,
                        permissionKey: $0.key.toKey()
                    )
                }
            )
    }

    // MARK: -

    public func list(
        _ input: User.Role.List.Query
    ) async throws -> User.Role.List {

        let queryBuilder = try await getQueryBuilder()

        var field: User.Role.Model.FieldKeys
        switch input.sort.by {
        case .key:
            field = .key
        case .name:
            field = .name
        }

        let filterGroup = input.search.flatMap { value in
            QueryFilterGroup<User.Role.Model.CodingKeys>(
                relation: .or,
                fields: [
                    .init(
                        field: .key,
                        operator: .like,
                        value: "%\(value)%"
                    ),
                    .init(
                        field: .name,
                        operator: .like,
                        value: "%\(value)%"
                    ),
                    .init(
                        field: .notes,
                        operator: .like,
                        value: "%\(value)%"
                    ),
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

        return try User.Role.List(
            items: result.items.map {
                try $0.toListItem()
            },
            count: UInt(result.total)
        )
    }

    public func reference(
        keys: [ID<User.Role>]
    ) async throws -> [User.Role.Reference] {
        let queryBuilder = try await getQueryBuilder()

        return
            try await queryBuilder.all(
                filter: .init(
                    field: .key,
                    operator: .in,
                    value: keys
                )
            )
            .map {
                try $0.toReference()
            }
    }

    public func create(
        _ input: User.Role.Create
    ) async throws -> User.Role.Detail {
        let queryBuilder = try await getQueryBuilder()

        try await input.validate(queryBuilder)
        let model = User.Role.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes
        )
        try await queryBuilder.insert(model)
        try await updateRolePermissions(
            input.permissionKeys,
            input.key
        )
        return try await get(key: model.key.toID())
    }

    public func get(
        key: ID<User.Role>
    ) async throws -> User.Role.Detail {
        try await getRoleBy(id: key)
    }

    public func update(
        key: ID<User.Role>,
        _ input: User.Role.Update
    ) async throws -> User.Role.Detail {
        let queryBuilder = try await getQueryBuilder()

        _ = try await queryBuilder.require(key)
        
        try await input.validate(key, queryBuilder)
        let newModel = User.Role.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes
        )
        try await queryBuilder.update(key, newModel)
        try await updateRolePermissions(
            input.permissionKeys,
            newModel.key.toID()
        )

        return try await get(key: newModel.key.toID())
    }

    public func patch(
        key: ID<User.Role>,
        _ input: User.Role.Patch
    ) async throws -> User.Role.Detail {
        let queryBuilder = try await getQueryBuilder()

        let oldModel = try await queryBuilder.require(key)
        
        try await input.validate(key, queryBuilder)
        let newModel = User.Role.Model(
            key: input.key?.toKey() ?? oldModel.key,
            name: input.name ?? oldModel.name,
            notes: input.notes ?? oldModel.notes
        )
        try await queryBuilder.update(key, newModel)
        if let permissionKeys = input.permissionKeys {
            try await updateRolePermissions(
                permissionKeys,
                newModel.key.toID()
            )
        }

        return try await get(key: newModel.key.toID())
    }

    public func bulkDelete(
        keys: [ID<User.Role>]
    ) async throws {
        let queryBuilder = try await getQueryBuilder()
        try await queryBuilder.delete(
            filter: .init(
                field: .key,
                operator: .in,
                value: keys
            )
        )
    }
}
