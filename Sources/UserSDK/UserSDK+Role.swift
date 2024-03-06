//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreSDKInterface
import FeatherComponent
import FeatherValidation
import Logging
import SQLKit
import SystemSDKInterface
import UserSDKInterface

extension UserSDK {

    public func listRoles(
        _ input: List.Query<
            User.Role.List.Sort
        >
    ) async throws
        -> List.Result<
            User.Role.List.Item,
            User.Role.List.Sort
        >
    {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(User.Role.ACL.list.rawValue)

        do {
            let db = try await components.relationalDatabase().connection()
            let queryBuilder = User.Role.Query(db: db)

            return
                try await queryBuilder.all(
                    query: .init(
                        input: input,
                        queryBuilderType: User.Role.Query.self
                    )
                )
                .toResult(input: input) { $0.toListItem() }
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    private func getRoleBy(
        id: ID<User.Role>
    ) async throws -> User.Role.Detail {
        let db = try await components.relationalDatabase().connection()
        let accountQB = User.Role.Query(db: db)
        guard
            let accountModel = try await accountQB.firstById(
                value: id.rawValue
            )
        else {
            throw UserSDKError.unknown
        }

        let roleKeys = try await User.RolePermission.Query(db: db)
            .select()
            .filter { $0.roleKey == accountModel.key }
            .map { $0.permissionKey }
            .map { ID<System.Permission>($0) }

        let permissions = try await system.getPermissionReferences(
            keys: roleKeys
        )

        return accountModel.toDetail(permissions: permissions)
    }

    private func updateRolePermissions(
        _ permissionKeys: [ID<System.Permission>],
        _ role: ID<User.Role>
    ) async throws {
        let db = try await components.relationalDatabase().connection()
        let permissions = try await system.getPermissionReferences(
            keys: permissionKeys
        )

        let rolePermissionQuery = User.RolePermission.Query(db: db)

        // drop all user roles
        try await rolePermissionQuery.db
            .delete(from: User.RolePermission.Query.tableName)
            .where(
                User.RolePermission.Query.FieldKeys.roleKey.rawValue,
                .equal,
                SQLBind(role.rawValue)
            )
            .run()

        // create role permission objects
        for permission in permissions {
            try await rolePermissionQuery.insert(
                .init(
                    roleKey: role.toKey(),
                    permissionKey: permission.key.toKey()
                )
            )
        }
    }

    public func createRole(
        _ input: User.Role.Create
    ) async throws -> User.Role.Detail {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(User.Role.ACL.create.rawValue)

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Role.Query(db: db)

            // NOTE: unique key validation workaround
            try await KeyValueValidator(
                key: "key",
                value: input.key.rawValue,
                rules: [
                    .init(
                        message: "Key needs to be unique",
                        { value in
                            guard
                                try await qb.firstById(
                                    value: input.key.rawValue
                                ) == nil
                            else {
                                throw RuleError.invalid
                            }
                        }
                    )
                ]
            )
            .validate()

            // TODO: proper validation
            //            try await input.validate()
            let model = User.Role.Model(input)
            try await qb.insert(model)

            try await updateRolePermissions(
                input.permissionKeys,
                model.key.toID()
            )
            return try await getRoleBy(id: model.key.toID())
        }
        catch let error as ValidatorError {
            throw UserSDKError.validation(error.failures)
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func getRole(
        key: ID<User.Role>
    ) async throws -> User.Role.Detail {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(User.Role.ACL.get.rawValue)

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Role.Query(db: db)
            guard let model = try await qb.firstById(value: key.rawValue) else {
                throw UserSDKError.unknown
            }
            return try await getRoleBy(id: model.key.toID())
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func updateRole(
        key: ID<User.Role>,
        _ input: User.Role.Update
    ) async throws -> User.Role.Detail {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(User.Role.ACL.update.rawValue)

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Role.Query(db: db)

            guard let model = try await qb.firstById(value: key.rawValue) else {
                throw UserSDKError.unknown
            }
            //TODO: validate input
            let newModel = model.updated(input)
            try await qb.update(key.rawValue, newModel)

            try await updateRolePermissions(
                input.permissionKeys,
                newModel.key.toID()
            )
            return try await getRoleBy(id: newModel.key.toID())
        }
        catch let error as ValidatorError {
            throw UserSDKError.validation(error.failures)
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func patchRole(
        key: ID<User.Role>,
        _ input: User.Role.Patch
    ) async throws -> User.Role.Detail {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(User.Role.ACL.update.rawValue)

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Role.Query(db: db)

            guard let model = try await qb.firstById(value: key.rawValue) else {
                throw UserSDKError.unknown
            }
            //TODO: validate input
            let newModel = model.patched(input)
            try await qb.update(key.rawValue, newModel)

            if let permissionKeys = input.permissionKeys {
                try await updateRolePermissions(
                    permissionKeys,
                    newModel.key.toID()
                )
            }

            return try await getRoleBy(id: newModel.key.toID())
        }
        catch let error as ValidatorError {
            throw UserSDKError.validation(error.failures)
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func bulkDeleteRole(keys: [ID<User.Role>]) async throws {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(User.Role.ACL.delete.rawValue)

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Role.Query(db: db)
            try await qb.delete(keys.map { $0.rawValue })
        }
        catch {
            throw UserSDKError.database(error)
        }
    }
}
