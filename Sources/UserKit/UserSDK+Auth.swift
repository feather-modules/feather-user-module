//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import Bcrypt
import FeatherComponent
import FeatherKit
import FeatherRelationalDatabase
import Foundation
import Logging
import SQLKit
import UserInterfaceKit

extension UserSDK {

    @discardableResult
    public func auth<T>(
        _ token: String,
        _ block: (() async throws -> T)
    ) async throws -> T {
        let user = try await auth(token)
        return try await ACL.authenticate(user, block)
    }

    public func auth(
        _ token: String
    ) async throws -> ACL.AuthenticatedUser {
        let db = try await components.relationalDatabase().connection()
        guard
            let tokenModel = try await User.Token.Query(db: db)
                .firstBy(key: .value, value: token)
        else {
            throw ACLError.unauthorized(.token)
        }

        guard
            let account = try await User.Account.Query(db: db)
                .firstBy(key: .id, value: tokenModel.accountId)
        else {
            throw ACLError.unauthorized(.token)
        }

        let roles = try await User.AccountRole.Query(db: db)
            .select()
            .filter { $0.accountId == account.id }
            .map { $0.roleKey }

        let rolePermissions = try await User.RolePermission.Query(db: db)
            .select()

        let permissions = rolePermissions.filter {
            roles.contains(.init($0.roleKey.rawValue))
        }

        return .init(
            accountId: .init(account.id.rawValue),
            roleKeys: roles.map(\.rawValue),
            permissionKeys: permissions.map(\.permissionKey)
        )
    }

    // TODO: handle bcrypt error
    public func postAuth(
        _ input: User.Auth.Request
    ) async throws -> User.Auth.Response {
        let db = try await components.relationalDatabase().connection()
        let qb = User.Account.Query(db: db)

        guard
            let account = try await qb.firstBy(key: .email, value: input.email)
        else {
            throw ACLError.unauthorized(.credentials)
        }
        let isValid = try Bcrypt.verify(
            input.password,
            created: account.password
        )
        guard isValid else {
            throw ACLError.unauthorized(.credentials)
        }

        let tokenQueryBuilder = User.Token.Query(db: db)
        let token = User.Token.Model.generate(.init(account.id.rawValue))
        try await tokenQueryBuilder.insert(token)

        // TODO: use joined query...
        let accountRoles = try await User.AccountRole.Query(db: db)
            .select()
            .filter { $0.accountId == account.id }
            .map { $0.roleKey }

        //        let rolePermissions = try await User.RolePermission.Query(db: db)
        //            .select()
        //
        //        let permissions = rolePermissions.filter {
        //            roles.contains(.init($0.roleKey.rawValue))
        //        }

        let roles = try await User.Role.Query(db: db).select()
            .filter { accountRoles.contains($0.key) }

        return .init(
            account: .init(
                id: .init(account.id.rawValue),
                email: account.email,
                roles: roles.map {
                    .init(
                        key: .init($0.key.rawValue),
                        name: $0.name
                    )
                }
            ),
            token: .init(
                value: .init(token.value),
                expiration: token.expiration
            ),
            roles: roles.map {
                .init(
                    key: .init($0.key.rawValue),
                    name: $0.name
                )
            }
        )
    }

    public func deleteAuth() async throws {
        // TODO: delete token from the table
        try await ACL.unset(ACL.AuthenticatedUser.self) {}
    }
}
