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
import SQLKit
import SystemSDKInterface
import UserSDKInterface


//let res = try await User.Role.Query.select(db) {
//    Column(.name)
//    FilterGroup(.and) {
//        Filter(.name, .equals, "foo")
//    }
//    Filter(.name, .equals, "foo")
//    Page {
//        Size(10)
//        Index(10)
//    }
//    Limit(10)
//    Offset(12)
//}
//.all()



extension UserSDK {

    private func getRoleBy(
        id: ID<User.Role>
    ) async throws -> User.Role.Detail {
//        let db = try await components.relationalDatabase().connection()
//        let accountQB = User.Role.Query(db: db)
        fatalError()
//        guard
//            let accountModel = try await accountQB.firstById(
//                value: id.rawValue
//            )
//        else {
//            throw UserSDKError.unknown
//        }
//
//        let roleKeys = try await User.RolePermission.Query(db: db)
//            .select()
//            .filter { $0.roleKey == accountModel.key }
//            .map { $0.permissionKey }
//            .map { ID<System.Permission>($0) }
//
//        let permissions =
//            try await system.referencePermissions(
//                keys: roleKeys
//            )
//            .map { try $0.convert(to: System.Permission.Reference.self) }
//
//        return User.Role.Detail(
//            key: accountModel.key.toID(),
//            name: accountModel.name,
//            notes: accountModel.notes,
//            permissions: permissions
//        )
    }

    private func updateRolePermissions(
        _ permissionKeys: [ID<System.Permission>],
        _ role: ID<User.Role>
    ) async throws {
        fatalError()
//        let db = try await components.relationalDatabase().connection()
//        let permissions = try await system.referencePermissions(
//            keys: permissionKeys
//        )
//
//        let rolePermissionQuery = User.RolePermission.Query(db: db)
//
//        // drop all user roles
//        try await rolePermissionQuery.db
//            .delete(from: User.RolePermission.Query.tableName)
//            .where(
//                User.RolePermission.Query.FieldKeys.roleKey.rawValue,
//                .equal,
//                SQLBind(role.rawValue)
//            )
//            .run()
//
//        // create role permission objects
//        for permission in permissions {
//            try await rolePermissionQuery.insert(
//                .init(
//                    roleKey: role.toKey(),
//                    permissionKey: permission.key.toKey()
//                )
//            )
//        }
    }

    // MARK: -

    public func listRoles(_ input: any UserRoleListQuery) async throws
        -> any UserRoleList
    {
        do {
//            let db = try await components.relationalDatabase().connection()
//            let queryBuilder = User.Role.Query(db: db)

//            let res = try await queryBuilder.all(
//                query: .init(
//                    page: .init(
//                        size: input.page.size,
//                        index: input.page.index
//                    ),
//                    search: .init(
//                        field: .name,
//                        method: .like,
//                        value: input.search
//                    ),
//                    sort: .init(
//                        field: .name,
//                        direction: .asc
//                    )
//                )
//            )

            //            let res = try await queryBuilder.db.select()
            //                .page(input.page)
            //                .limit(input.page.toQuery.limit)
            //                .offset(input.page.toQuery.limit)
            //                .all()

            fatalError()
            //            try await queryBuilder.all(
            //                query: .init(
            //                    input: input,
            //                    queryBuilderType: User.Role.Query.self
            //                )
            //            )

        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func bulkDeleteRole(keys: [CoreSDKInterface.ID<User.Role>])
        async throws
    {
        fatalError()
    }

    public func referenceRoles(keys: [ID<User.Role>]) async throws
        -> [UserRoleReference]
    {
        fatalError()
    }

    public func createRole(_ input: UserRoleCreate) async throws
        -> UserRoleDetail
    {
        do {
//            let db = try await components.relationalDatabase().connection()
//            let qb = User.Role.Query(db: db)

            fatalError()
            // NOTE: unique key validation workaround
//            try await KeyValueValidator(
//                key: "key",
//                value: input.key.rawValue,
//                rules: [
//                    .init(
//                        message: "Key needs to be unique",
//                        { value in
//                            guard
//                                try await qb.firstById(
//                                    value: input.key.rawValue
//                                ) == nil
//                            else {
//                                throw RuleError.invalid
//                            }
//                        }
//                    )
//                ]
//            )
//            .validate()

            // TODO: proper validation
            //            try await input.validate()
//            let model = User.Role.Model(
//                key: input.key.toKey(),
//                name: input.name,
//                notes: input.notes
//            )
//            try await qb.insert(model)
//
//            try await updateRolePermissions(
//                input.permissionKeys,
//                model.key.toID()
//            )
//            return try await getRoleBy(id: model.key.toID())
        }
        catch let error as ValidatorError {
            throw UserSDKError.validation(error.failures)
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func getRole(key: ID<User.Role>) async throws -> UserRoleDetail {
        do {
            fatalError()
//            let db = try await components.relationalDatabase().connection()
//            let qb = User.Role.Query(db: db)
//            guard let model = try await qb.firstById(value: key.rawValue) else {
//                throw UserSDKError.unknown
//            }
//            return try await getRoleBy(id: model.key.toID())
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func updateRole(key: ID<User.Role>, _ input: UserRoleUpdate)
        async throws -> UserRoleDetail
    {
        fatalError()
    }

    public func patchRole(key: ID<User.Role>, _ input: UserRolePatch)
        async throws -> UserRoleDetail
    {
        fatalError()
    }

    //
    //    public func updateRole(
    //        key: ID<User.Role>,
    //        _ input: User.Role.Update
    //    ) async throws -> User.Role.Detail {
    //        let user = try await ACL.require(ACL.AuthenticatedUser.self)
    //        try await user.requirePermission(User.Role.ACL.update.rawValue)
    //
    //        do {
    //            let db = try await components.relationalDatabase().connection()
    //            let qb = User.Role.Query(db: db)
    //
    //            guard let model = try await qb.firstById(value: key.rawValue) else {
    //                throw UserSDKError.unknown
    //            }
    //            //TODO: validate input
    //            let newModel = model.updated(input)
    //            try await qb.update(key.rawValue, newModel)
    //
    //            try await updateRolePermissions(
    //                input.permissionKeys,
    //                newModel.key.toID()
    //            )
    //            return try await getRoleBy(id: newModel.key.toID())
    //        }
    //        catch let error as ValidatorError {
    //            throw UserSDKError.validation(error.failures)
    //        }
    //        catch {
    //            throw UserSDKError.database(error)
    //        }
    //    }
    //
    //    public func patchRole(
    //        key: ID<User.Role>,
    //        _ input: User.Role.Patch
    //    ) async throws -> User.Role.Detail {
    //        let user = try await ACL.require(ACL.AuthenticatedUser.self)
    //        try await user.requirePermission(User.Role.ACL.update.rawValue)
    //
    //        do {
    //            let db = try await components.relationalDatabase().connection()
    //            let qb = User.Role.Query(db: db)
    //
    //            guard let model = try await qb.firstById(value: key.rawValue) else {
    //                throw UserSDKError.unknown
    //            }
    //            //TODO: validate input
    //            let newModel = model.patched(input)
    //            try await qb.update(key.rawValue, newModel)
    //
    //            if let permissionKeys = input.permissionKeys {
    //                try await updateRolePermissions(
    //                    permissionKeys,
    //                    newModel.key.toID()
    //                )
    //            }
    //
    //            return try await getRoleBy(id: newModel.key.toID())
    //        }
    //        catch let error as ValidatorError {
    //            throw UserSDKError.validation(error.failures)
    //        }
    //        catch {
    //            throw UserSDKError.database(error)
    //        }
    //    }
    //
    //    public func bulkDeleteRole(keys: [ID<User.Role>]) async throws {
    //        let user = try await ACL.require(ACL.AuthenticatedUser.self)
    //        try await user.requirePermission(User.Role.ACL.delete.rawValue)
    //
    //        do {
    //            let db = try await components.relationalDatabase().connection()
    //            let qb = User.Role.Query(db: db)
    //            try await qb.delete(keys.map { $0.rawValue })
    //        }
    //        catch {
    //            throw UserSDKError.database(error)
    //        }
    //    }
}
