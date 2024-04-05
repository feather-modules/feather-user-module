//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import Bcrypt
import FeatherComponent
import FeatherModuleKit
import Foundation
import Logging
import NanoID
import SystemModuleKit
import UserModuleKit

struct RegisterRepository: UserRegisterInterface {

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

        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()

        // validate invitation token
        let accountInvitationQueryBuilder = User.AccountInvitation.Query(db: db)
        let accountInvitation = try await accountInvitationQueryBuilder.first(
            filter: .init(
                field: .token,
                operator: .equal,
                value: [invitationToken]
            )
        )
        guard
            let accountInvitation = accountInvitation,
            accountInvitation.expiration > Date()
        else {
            throw User.Error.invalidInvitationToken
        }

        // validate account
        let input = try input.sanitized()
        let accountQueryBuilder = try await getQueryBuilder()
        let account = User.Account.Model(
            id: NanoID.generateKey(),
            email: input.email,
            password: try Bcrypt.hash(input.password)
        )
        try await input.validate(accountQueryBuilder)
        try await accountQueryBuilder.insert(account)

        // update roles for account
        try await updateAccountRoles(
            input.roleKeys,
            account.id.toID()
        )

        // generate token for the account
        let tokenQueryBuilder = User.Token.Query(db: db)
        let token = User.Token.Model.generate(.init(account.id.rawValue))
        try await tokenQueryBuilder.insert(token)

        return try await getAuthResponse(account: account, token: token)
    }

    private func getQueryBuilder() async throws -> User.Account.Query {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)
    }

    private func updateAccountRoles(
        _ roleKeys: [ID<User.Role>],
        _ id: ID<User.Account>
    ) async throws {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        let queryBuilder = User.Account.Query(db: db)
        guard try await queryBuilder.get(id) != nil else {
            throw User.Error.unknown
        }

        let roles = try await user.role.reference(keys: roleKeys)
        try await queryBuilder.roleQueryBuilder()
            .delete(
                filter: .init(
                    field: .accountId,
                    operator: .equal,
                    value: id
                )
            )
        try await queryBuilder.roleQueryBuilder()
            .insert(
                roles.map {
                    User.AccountRole.Model(
                        accountId: id.toKey(),
                        roleKey: $0.key.toKey()
                    )
                }
            )
    }

    private func getAccountBy(
        id: ID<User.Account>
    ) async throws -> User.Account.Detail {
        let queryBuilder = try await getQueryBuilder()

        guard let model = try await queryBuilder.get(id) else {
            throw User.Error.unknown
        }

        let roleKeys =
            try await queryBuilder
            .roleQueryBuilder()
            .all(
                filter: .init(
                    field: .accountId,
                    operator: .equal,
                    value: id
                )
            )
            .map { $0.roleKey }
            .map { $0.toID() }

        let roles = try await user.role.reference(keys: roleKeys)

        return User.Account.Detail(
            id: model.id.toID(),
            email: model.email,
            roles: roles
        )
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

}
