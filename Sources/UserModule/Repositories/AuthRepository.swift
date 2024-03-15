//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import Bcrypt
import CoreModuleInterface
import FeatherACL
import FeatherComponent
import FeatherRelationalDatabase
import Foundation
import Logging
import SQLKit
import SystemModuleInterface
import UserModuleInterface

struct AuthRepository: UserAuthInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface
    
    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    private func getAuthResponse(
        account: User.Account.Model,
        token: User.Token.Model
    ) async throws -> User.Auth.Response {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        let accountQueryBuilder = User.Account.Query(db: db)

        let roleKeys = try await accountQueryBuilder.roleQueryBuilder()
            .all(
                filter: .init(
                    field: .accountId,
                    operator: .equal,
                    value: account.id
                )
            )
            .map { $0.roleKey }
            .map { $0.toID() }

        let permissionKeys = try await User.RolePermission.Query(db: db)
            .all(
                filter: .init(
                    field: .roleKey,
                    operator: .in,
                    value: roleKeys
                )
            )
            .map { $0.permissionKey }
            .map { $0.toID() }

        let roles = try await user.role.reference(keys: roleKeys)
            .map { User.Role.Reference(key: $0.key, name: $0.name) }

        return User.Auth.Response(
            account: User.Account.Detail(
                id: account.id.toID(),
                email: account.email,
                roles: roles
            ),
            token: User.Token.Detail(
                value: .init(rawValue: token.value),
                expiration: token.expiration
            ),
            permissions: permissionKeys
        )
    }
    // TODO: throw user error with token
    public func auth(
        _ token: String
    ) async throws -> User.Auth.Response {

        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        let tokenQueryBuilder = User.Token.Query(db: db)
        let accountQueryBuilder = User.Account.Query(db: db)

        guard
            let token = try await tokenQueryBuilder.get(token),
            let account = try await accountQueryBuilder.get(token.accountId)
        else {
            throw AccessControlError.unauthorized
        }

        return try await getAuthResponse(account: account, token: token)
    }

    // TODO: handle bcrypt error
    public func auth(
        _ credentials: User.Auth.Request
    ) async throws -> User.Auth.Response {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        let tokenQueryBuilder = User.Token.Query(db: db)
        let accountQueryBuilder = User.Account.Query(db: db)

        guard
            let account = try await accountQueryBuilder.first(
                filter: .init(
                    field: .email,
                    operator: .equal,
                    value: credentials.email
                )
            )
        else {
            throw AccessControlError.unauthorized
        }
        let isValid = try Bcrypt.verify(
            credentials.password,
            created: account.password
        )
        guard isValid else {
            throw AccessControlError.unauthorized
        }

        let token = User.Token.Model.generate(.init(account.id.rawValue))
        try await tokenQueryBuilder.insert(token)

        return try await getAuthResponse(account: account, token: token)
    }

    public func deleteAuth() async throws {
        // TODO: delete token from the table
    }
}
