//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import Logging
import SystemModuleKit
import UserModuleKit

struct RoleController: UserRoleInterface, ControllerDelete,
    ControllerList,
    ControllerReference
{
    
    typealias Query = User.Role.Query
    typealias Reference = User.Role.Reference
    typealias List = User.Role.List

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .key, .name, .type
        ]

    // MARK: -

    func create(_ input: User.Role.Create) async throws -> User.Role.Detail {
        let db = try await components.database().connection()
        try await input.validate(on: db)
        
        let model = User.Role.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes,
            type: input.type.check().rawValue
        )

        try await User.Role.Query.insert(model, on: db)
        try await updateRolePermissions(
            input.permissionKeys,
            input.key,
            db
        )
        return try await getRoleBy(id: model.key.toID(), db)
    }

    func require(_ id: ID<User.Role>) async throws -> User.Role.Detail {
        let db = try await components.database().connection()
        return try await getRoleBy(id: id, db)
    }

    func update(
        _ id: ID<User.Role>,
        _ input: User.Role.Update
    ) async throws -> User.Role.Detail {
        let db = try await components.database().connection()

        try await User.Role.Query.require(id.toKey(), on: db)
        try await input.validate(id, on: db)

        let newModel = User.Role.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes,
            type: input.type.check().rawValue
        )

        try await User.Role.Query.update(id.toKey(), newModel, on: db)
        try await updateRolePermissions(
            input.permissionKeys,
            newModel.key.toID(),
            db
        )
        return try await getRoleBy(id: newModel.key.toID(), db)
    }

    func patch(
        _ id: ID<User.Role>,
        _ input: User.Role.Patch
    ) async throws -> User.Role.Detail {
        let db = try await components.database().connection()
        let oldModel = try await User.Role.Query.require(id.toKey(), on: db)

        try await input.validate(id, on: db)
        let newModel = User.Role.Model(
            key: input.key?.toKey() ?? oldModel.key,
            name: input.name ?? oldModel.name,
            notes: input.notes ?? oldModel.notes,
            type: input.type.check().rawValue
        )
        try await User.Role.Query.update(id.toKey(), newModel, on: db)
        if let permissionKeys = input.permissionKeys {
            try await updateRolePermissions(
                permissionKeys,
                newModel.key.toID(),
                db
            )
        }
        return try await getRoleBy(id: newModel.key.toID(), db)
    }

    private func getRoleBy(
        id: ID<User.Role>,
        _ db: Database
    ) async throws -> User.Role.Detail {
        let model = try await User.Role.Query.require(id.toKey(), on: db)
        let permissionKeys = try await User.RolePermission.Query
            .listAll(
                filter: .init(
                    column: .roleKey,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
            .map { $0.permissionKey }
            .map { $0.toID() }

        let permissions = try await user.system.permission.reference(
            ids: permissionKeys
        )

        return User.Role.Detail(
            key: model.key.toID(),
            name: model.name,
            notes: model.notes,
            type: model.type.toRoleType(),
            permissions: permissions
        )
    }

    private func updateRolePermissions(
        _ permissionKeys: [ID<System.Permission>],
        _ role: ID<User.Role>,
        _ db: Database
    ) async throws {
        try await User.Role.Query.require(role.toKey(), on: db)

        let permissions = try await user.system.permission.reference(
            ids: permissionKeys
        )
        try await User.RolePermission.Query.delete(
            filter: .init(
                column: .roleKey,
                operator: .equal,
                value: role
            ),
            on: db
        )
        try await User.RolePermission.Query
            .insert(
                permissions.map {
                    User.RolePermission.Model(
                        roleKey: role.toKey(),
                        permissionKey: $0.key.toKey()
                    )
                },
                on: db
            )
    }

}
