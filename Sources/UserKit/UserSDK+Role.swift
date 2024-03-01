//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreInterfaceKit
import FeatherComponent
import FeatherValidation
import Logging
import SystemInterfaceKit
import UserInterfaceKit

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

            // TODO: better SDK
            var permissions: [System.Permission.Reference] = []
            for permissionKey in input.permissionKeys {
                let permission = try await system.getPermission(
                    key: .init(permissionKey.rawValue)
                )
                permissions.append(
                    .init(
                        key: .init(permission.key.rawValue),
                        name: permission.name
                    )
                )
            }

            let rolePermissionQB = User.RolePermission.Query(db: db)

            try await rolePermissionQB.insert(
                input.permissionKeys.map {
                    .init(
                        roleKey: model.key,
                        permissionKey: $0.rawValue
                    )
                }
            )

            return model.toDetail(permissions: permissions)
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
            return model.toDetail(permissions: [])
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
            return newModel.toDetail(permissions: [])
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
            return newModel.toDetail(permissions: [])
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
