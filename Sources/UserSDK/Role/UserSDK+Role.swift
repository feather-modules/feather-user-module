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

public enum QueryDirection {
    case asc
    case desc
}

public protocol QueryFieldKey: RawRepresentable where RawValue == String {

}

extension QueryFieldKey {

    var sqlField: String {
        rawValue
    }
}

public protocol QuerySortInterface {
    associatedtype Field: QueryFieldKey

    var field: Field { get }
    var direction: QueryDirection { get }
}

public struct QuerySort<F: QueryFieldKey>: QuerySortInterface {
    public let field: F
    public let direction: QueryDirection

    public init(field: F, direction: QueryDirection) {
        self.field = field
        self.direction = direction
    }
}

public struct QueryLimit {

    public let value: UInt

    public init(_ value: UInt) {
        self.value = value
    }
}

public struct QueryOffset {

    public let value: UInt

    public init(_ value: UInt) {
        self.value = value
    }
}

public struct QueryPage {

    public let limit: QueryLimit
    public let offset: QueryOffset

    public init(
        size: UInt,
        index: UInt
    ) {
        self.limit = .init(size)
        self.offset = .init(size * index)
    }

    var sqlLimit: Int {
        Int(limit.value)
    }

    var sqlOffset: Int {
        Int(offset.value)
    }
}

public enum QueryFilterMethod {
    case equals
    case like

    var sqlOperator: SQLBinaryOperator {
        switch self {
        case .equals: .equal
        case .like: .like
        }
    }
}

public protocol QueryFilterInterface {
    associatedtype Field: QueryFieldKey

    var field: Field { get }
}

public struct QueryFilter<F: QueryFieldKey>: QueryFilterInterface {
    public let field: F
    public let method: QueryFilterMethod
    public let value: any Encodable

    public init(
        field: F,
        method: QueryFilterMethod,
        value: any Encodable
    ) {
        self.field = field
        self.method = method
        self.value = value
    }

    var sqlValue: SQLBind {
        SQLBind(value)
    }
}

protocol ListQueryInterface {
    associatedtype Field: QueryFieldKey

    var page: QueryPage { get }
    var search: QueryFilter<Field> { get }
    var sort: QuerySort<Field> { get }
}

public struct SimpleListQuery<F: QueryFieldKey>: ListQueryInterface {
    public let page: QueryPage
    public let search: QueryFilter<F>
    public let sort: QuerySort<F>
}

public protocol QB {

    var db: SQLDatabase { get }
    static var tableName: String { get }

    associatedtype Row: Codable
    associatedtype FieldKeys: QueryFieldKey
}

extension QB {

    func all<T: Decodable>(
        query: SimpleListQuery<FieldKeys>
    ) async throws -> [T] {
        try await db.select()
            .column("*")
            .limit(query.page.sqlLimit)
            .offset(query.page.sqlOffset)
            .where(
                query.search.field.sqlField,
                query.search.method.sqlOperator,
                query.search.sqlValue
            )
            .all(decoding: T.self)
    }

}

extension User.Role.Query: QB {}
extension User.Role.Model.CodingKeys: QueryFieldKey {}

extension UserSDK {

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

        let permissions =
            try await system.referencePermissions(
                keys: roleKeys
            )
            .map { try $0.convert(to: System.Permission.Reference.self) }

        return User.Role.Detail(
            key: accountModel.key.toID(),
            name: accountModel.name,
            notes: accountModel.notes,
            permissions: permissions
        )
    }

    private func updateRolePermissions(
        _ permissionKeys: [ID<System.Permission>],
        _ role: ID<User.Role>
    ) async throws {
        let db = try await components.relationalDatabase().connection()
        let permissions = try await system.referencePermissions(
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

    // MARK: -

    public func listRoles(_ input: any UserRoleListQuery) async throws
        -> any UserRoleList
    {
        do {
            let db = try await components.relationalDatabase().connection()
            let queryBuilder = User.Role.Query(db: db)

            let res: [User.Role.Model] = try await queryBuilder.all(
                query: .init(
                    page: .init(size: input.page.size, index: input.page.index),
                    search: .init(
                        field: .name,
                        method: .like,
                        value: input.search
                    ),
                    sort: .init(
                        field: .name,
                        direction: .asc
                    )
                )
            )

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
            let model = User.Role.Model(
                key: input.key.toKey(),
                name: input.name,
                notes: input.notes
            )
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

    public func getRole(key: ID<User.Role>) async throws -> UserRoleDetail {
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
