//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreSDKInterface
import DatabaseQueryKit
import FeatherComponent
import FeatherValidation
import Logging
import SystemSDKInterface
import UserSDKInterface

// TODO: move this to the core sdk
extension Order {
    var queryDirection: QueryDirection {
        switch self {
        case .asc: .asc
        case .desc: .desc
        }
    }
}

extension User.Role.Query {

    func permissionQueryBuilder() async throws -> User.RolePermission.Query {
        .init(db: db)
    }
}

extension UserSDK {

    private func getQueryBuilder() async throws -> User.Role.Query {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)
    }
}

extension UserSDK {

    private func getRoleBy(
        id: ID<User.Role>
    ) async throws -> User.Role.Detail {
        let queryBuilder = try await getQueryBuilder()

        guard let model = try await queryBuilder.get(id) else {
            throw UserSDKError.unknown
        }

        let permissionKeys =
            try await queryBuilder
            .permissionQueryBuilder()
            .all(
                .roleKey,
                .equal,
                id
            )
            .map { $0.permissionKey }
            .map { $0.toID() }

        let permissions =
            try await system.referencePermissions(
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
        guard try await queryBuilder.get(role) != nil else {
            throw UserSDKError.unknown
        }

        let permissions = try await system.referencePermissions(
            keys: permissionKeys
        )
        try await queryBuilder.permissionQueryBuilder()
            .delete(.roleKey, .equal, role)
        try await queryBuilder.permissionQueryBuilder()
            .insert(
                permissions.map {
                    User.RolePermission.Model(
                        roleKey: role.toKey(),
                        permissionKey: $0.key.toKey()
                    )
                }
            )
    }

    // MARK: -

    public func listRoles(
        _ input: any UserRoleListQuery
    ) async throws -> any UserRoleList {

        let queryBuilder = try await getQueryBuilder()

        var field: User.Role.Model.FieldKeys
        switch input.sort.by {
        case .key:
            field = .key
        case .name:
            field = .name
        }

        let search = input.search.flatMap { value in
            QueryFilter<User.Role.Model.CodingKeys>(
                field: .key,
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

        return try User.Role.List(
            items: result.items.map {
                try $0.convert(to: User.Role.List.Item.self)
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

    public func referenceRoles(
        keys: [ID<User.Role>]
    ) async throws -> [UserRoleReference] {
        let queryBuilder = try await getQueryBuilder()

        return try await queryBuilder.all(.key, .in, keys)
            .convert(to: [User.Role.Reference].self)
    }

    public func createRole(
        _ input: UserRoleCreate
    ) async throws -> UserRoleDetail {
        let queryBuilder = try await getQueryBuilder()

        let model = try input.convert(to: User.Role.Model.self)
        try await queryBuilder.insert(model)
        try await updateRolePermissions(
            input.permissionKeys,
            input.key
        )
        return try await getRole(key: model.key.toID())
    }

    public func getRole(key: ID<User.Role>) async throws -> UserRoleDetail {
        try await getRoleBy(id: key)
    }

    public func updateRole(
        key: ID<User.Role>,
        _ input: UserRoleUpdate
    ) async throws -> UserRoleDetail {
        let queryBuilder = try await getQueryBuilder()

        guard try await queryBuilder.get(key) != nil else {
            throw UserSDKError.unknown
        }
        //TODO: validate input
        let newModel = User.Role.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes
        )
        try await queryBuilder.update(key, newModel)
        try await updateRolePermissions(input.permissionKeys, key)

        return try await getRole(key: newModel.key.toID())
    }

    public func patchRole(
        key: ID<User.Role>,
        _ input: UserRolePatch
    ) async throws -> UserRoleDetail {
        let queryBuilder = try await getQueryBuilder()

        guard let oldModel = try await queryBuilder.get(key) else {
            throw UserSDKError.unknown
        }
        //TODO: validate input
        let newModel = User.Role.Model(
            key: input.key?.toKey() ?? oldModel.key,
            name: input.name ?? oldModel.name,
            notes: input.notes ?? oldModel.notes
        )
        try await queryBuilder.update(key, newModel)
        if let permissionKeys = input.permissionKeys {
            try await updateRolePermissions(permissionKeys, key)
        }

        return try await getRole(key: newModel.key.toID())
    }

    public func bulkDeleteRole(
        keys: [ID<User.Role>]
    ) async throws {
        let queryBuilder = try await getQueryBuilder()
        try await queryBuilder.delete(keys)
    }
}
