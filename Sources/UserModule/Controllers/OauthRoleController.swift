//
//  File.swift
//
//  Created by gerp83 on 11/09/2024
//
    

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import Logging
import SystemModuleKit
import UserModuleKit

struct OauthRoleController: UserOauthRoleInterface,
    ControllerDelete,
    ControllerList,
    ControllerReference
{
    
    typealias Query = User.OauthRole.Query
    typealias Reference = User.OauthRole.Reference
    typealias List = User.OauthRole.List
    
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
        .key, .name,
    ]
    
    func create(_ input: User.OauthRole.Create) async throws -> User.OauthRole.Detail {
        let db = try await components.database().connection()
        try await input.validate(on: db)

        let model = User.OauthRole.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes
        )

        try await User.OauthRole.Query.insert(model, on: db)
        try await updateRolePermissions(
            input.permissionKeys,
            input.key,
            db
        )
        return try await getRoleBy(id: model.key.toID(), db)
    }

    func require(_ id: ID<User.OauthRole>) async throws -> User.OauthRole.Detail {
        let db = try await components.database().connection()
        return try await getRoleBy(id: id, db)
    }

    func update(
        _ id: ID<User.OauthRole>,
        _ input: User.OauthRole.Update
    ) async throws -> User.OauthRole.Detail {
        let db = try await components.database().connection()

        try await User.OauthRole.Query.require(id.toKey(), on: db)
        try await input.validate(id, on: db)

        let newModel = User.OauthRole.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes
        )

        try await User.OauthRole.Query.update(id.toKey(), newModel, on: db)
        try await updateRolePermissions(
            input.permissionKeys,
            newModel.key.toID(),
            db
        )
        return try await getRoleBy(id: newModel.key.toID(), db)
    }

    func patch(
        _ id: ID<User.OauthRole>,
        _ input: User.OauthRole.Patch
    ) async throws -> User.OauthRole.Detail {
        let db = try await components.database().connection()
        let oldModel = try await User.OauthRole.Query.require(id.toKey(), on: db)

        try await input.validate(id, on: db)
        let newModel = User.OauthRole.Model(
            key: input.key?.toKey() ?? oldModel.key,
            name: input.name ?? oldModel.name,
            notes: input.notes ?? oldModel.notes
        )
        try await User.OauthRole.Query.update(id.toKey(), newModel, on: db)
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
        id: ID<User.OauthRole>,
        _ db: Database
    ) async throws -> User.OauthRole.Detail {
        let model = try await User.OauthRole.Query.require(id.toKey(), on: db)
        
        let permissionKeys = try await User.OauthRolePermission.Query
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

        return User.OauthRole.Detail(
            key: model.key.toID(),
            name: model.name,
            notes: model.notes,
            permissions: permissions
        )
    }

    private func updateRolePermissions(
        _ permissionKeys: [ID<System.Permission>],
        _ role: ID<User.OauthRole>,
        _ db: Database
    ) async throws {
        try await User.OauthRole.Query.require(role.toKey(), on: db)

        let permissions = try await user.system.permission.reference(
            ids: permissionKeys
        )
        try await User.OauthRolePermission.Query.delete(
            filter: .init(
                column: .roleKey,
                operator: .equal,
                value: role
            ),
            on: db
        )
        try await User.OauthRolePermission.Query
            .insert(
                permissions.map {
                    User.OauthRolePermission.Model(
                        roleKey: role.toKey(),
                        permissionKey: $0.key.toKey()
                    )
                },
                on: db
            )
    }
    
    func getPermissionsKeys(_ roleKeys: [ID<User.OauthRole>]) async throws -> [ID<System.Permission>] {
        let db = try await components.database().connection()
        return try await User.OauthRolePermission.Query
            .listAll(
                filter: .init(
                    column: .roleKey,
                    operator: .in,
                    value: roleKeys
                ),
                on: db
            )
            .map { $0.permissionKey }
            .map { $0.toID() }
    }
    
}
