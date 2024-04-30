//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import Bcrypt
import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import Logging
import NanoID
import SystemModuleKit
import UserModuleKit

struct RegisterController: UserRegisterInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    public func register(
        invitationToken: String,
        _ input: User.Account.Create
    ) async throws -> User.Auth.Response {
        let db = try await components.database().connection()

        // validate invitation token
        let accountInvitation = try await User.AccountInvitation.Query.getFirst(
            filter: .init(
                column: .token,
                operator: .equal,
                value: [invitationToken]
            ),
            on: db
        )
        guard
            let accountInvitation = accountInvitation,
            accountInvitation.expiration > Date()
        else {
            throw User.Error.invalidInvitationToken
        }

        // validate account
        let input = try input.sanitized()
        let account = User.Account.Model(
            id: NanoID.generateKey(),
            email: input.email,
            password: input.password
        )
        try await input.validate(on: db)
        try await User.Account.Query.insert(account, on: db)

        // update roles for account
        try await updateAccountRoles(
            input.roleKeys,
            account.id.toID(),
            db
        )

        // generate token for the account
        let token = User.Token.Model.generate(
            .init(rawValue: account.id.rawValue)
        )
        try await User.Token.Query.insert(token, on: db)

        return try await getAuthResponse(account: account, token: token, db)
    }

    private func updateAccountRoles(
        _ roleKeys: [ID<User.Role>],
        _ id: ID<User.Account>,
        _ db: Database
    ) async throws {
        guard try await User.Account.Query.get(id.toKey(), on: db) != nil else {
            throw User.Error.unknown
        }
        let roles = try await user.role.reference(ids: roleKeys)
        try await User.AccountRole.Query
            .delete(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
        try await User.AccountRole.Query
            .insert(
                roles.map {
                    User.AccountRole.Model(
                        accountId: id.toKey(),
                        roleKey: $0.key.toKey()
                    )
                },
                on: db
            )
    }

    private func getAccountBy(
        id: ID<User.Account>,
        _ db: Database
    ) async throws -> User.Account.Detail {
        guard let model = try await User.Account.Query.get(id.toKey(), on: db)
        else {
            throw User.Error.unknown
        }
        let roleKeys = try await User.AccountRole.Query
            .listAll(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
            .map { $0.roleKey }
            .map { $0.toID() }
        let roles = try await user.role.reference(ids: roleKeys)
        return User.Account.Detail(
            id: model.id.toID(),
            email: model.email,
            roles: roles
        )
    }

    private func getAuthResponse(
        account: User.Account.Model,
        token: User.Token.Model,
        _ db: Database
    ) async throws -> User.Auth.Response {
        let roleKeys = try await User.AccountRole.Query
            .listAll(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: account.id
                ),
                on: db
            )
            .map { $0.roleKey }
            .map { $0.toID() }
        let permissionKeys = try await User.RolePermission.Query
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
        let roles = try await user.role.reference(ids: roleKeys)
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

}
