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

        let typesArray = try await User.AccountInvitationTypeSave.Query.listAll(
            orders: [],
            filter: .init(
                column: .invitationtId,
                operator: .equal,
                value: accountInvitation.id
            ),
            on: db
        )
        if typesArray.isEmpty {
            throw User.Error.invalidInvitationToken
        }

        // validate account
        let input = try input.sanitized()
        let account = User.Account.Model(
            id: NanoID.generateKey(),
            email: input.email,
            password: input.password,
            firstName: input.firstName,
            lastName: input.lastName,
            imageKey: input.imageKey
        )
        try await input.validate(on: db)
        try await User.Account.Query.insert(account, on: db)

        // get roles from invite
        let roles = try await User.Role.Query.listAll(
            orders: [],
            filter: .init(
                column: .key,
                operator: .in,
                value: typesArray.map { $0.typeKey }
            ),
            on: db
        )

        if roles.isEmpty {
            throw User.Error.invalidInvitationToken
        }

        // update roles for account
        try await updateAccountRoles(
            roles.map { $0.key.toID() },
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
        try await User.Account.Query.require(id.toKey(), on: db)
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
        let model = try await User.Account.Query.require(id.toKey(), on: db)
        let data = try await id.getRolesAndPermissonsForId(user, db)
        return User.Account.Detail(
            id: model.id.toID(),
            email: model.email,
            firstName: model.firstName,
            lastName: model.lastName,
            imageKey: model.imageKey,
            roles: data.0,
            permissions: data.1
        )
    }

    private func getAuthResponse(
        account: User.Account.Model,
        token: User.Token.Model,
        _ db: Database
    ) async throws -> User.Auth.Response {
        let data = try await account.id.toID()
            .getRolesAndPermissonsForId(user, db)
        return User.Auth.Response(
            account: User.Account.Detail(
                id: account.id.toID(),
                email: account.email,
                firstName: account.firstName,
                lastName: account.lastName,
                imageKey: account.imageKey,
                roles: data.0,
                permissions: data.1
            ),
            token: User.Token.Detail(
                value: .init(rawValue: token.value),
                expiration: token.expiration
            ),
            permissions: data.1
        )
    }

}
