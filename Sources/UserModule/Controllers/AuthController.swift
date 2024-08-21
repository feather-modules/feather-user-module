//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import Bcrypt
import FeatherACL
import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import Logging
import SQLKit
import SystemModuleKit
import UserModuleKit

struct AuthController: UserAuthInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    public func auth(_ token: String) async throws -> User.Auth.Response {
        let db = try await components.database().connection()

        let token = try await User.Token.Query.getFirst(
            filter: .init(
                column: .value,
                operator: .equal,
                value: token
            ),
            on: db
        )

        guard let token else {
            throw User.Error.invalidAuthToken
        }
        let account = try await User.Account.Query.get(token.accountId, on: db)

        guard let account else {
            throw User.Error.invalidAuthToken
        }

        return try await getAuthResponse(account: account, token: token, db)
    }

    public func auth(id: ID<User.Account>) async throws -> User.Auth.Response {
        let db = try await components.database().connection()

        let token = try await User.Token.Query.getFirst(
            filter: .init(
                column: .accountId,
                operator: .equal,
                value: id
            ),
            on: db
        )
        guard let token else {
            throw User.Error.invalidAuthToken
        }

        let account = try await User.Account.Query.get(token.accountId, on: db)
        guard let account else {
            throw User.Error.invalidAuthToken
        }

        return try await getAuthResponse(account: account, token: token, db)
    }

    public func auth(
        _ credentials: User.Auth.Request
    ) async throws -> User.Auth.Response {
        let db = try await components.database().connection()
        guard
            let account = try await User.Account.Query.getFirst(
                filter: .init(
                    column: .email,
                    operator: .equal,
                    value: credentials.email
                ),
                on: db
            )
        else {
            throw AccessControlError.unauthorized
        }
        let isValid = try Bcrypt.verify(
            credentials.password,
            created: account.password
        )
        guard isValid else {
            throw User.Error.invalidPassword
        }
        let token = User.Token.Model.generate(
            .init(rawValue: account.id.rawValue)
        )
        try await User.Token.Query.insert(token, on: db)
        return try await getAuthResponse(account: account, token: token, db)
    }

    public func deleteAuth(_ id: ID<User.Account>) async throws {
        let db = try await components.database().connection()
        try await User.Token.Query.delete(
            filter: .init(
                column: .accountId,
                operator: .equal,
                value: id
            ),
            on: db
        )
    }
}

extension AuthController {

    fileprivate func getAuthResponse(
        account: User.Account.Model,
        token: User.Token.Model,
        _ db: Database
    ) async throws -> User.Auth.Response {
        let data = try await account.id.toID().getRolesAndPermissonsForId(user, db)
        return User.Auth.Response(
            account: User.Account.Detail(
                id: account.id.toID(),
                email: account.email,
                roles: data.0,
                permissions: data.1
            ),
            token: User.Token.Detail(
                value: .init(rawValue: token.value),
                expiration: token.expiration
            )
        )
    }
}
