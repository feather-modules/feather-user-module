//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherACL
import FeatherComponent
import FeatherModuleKit
import Logging
import SystemModuleKit
import UserModuleKit

struct ProfileRepository: UserProfileInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    // MARK: -

    public func get() async throws -> User.Account.Detail {
        let acl = try await AccessControl.require(ACL.self)

        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        let accountQueryBuilder = User.Account.Query(db: db)

        guard let account = try await accountQueryBuilder.get(acl.accountId)
        else {
            throw AccessControlError.unauthorized
        }

        // TODO: replace it with join?
        let accountRoleKeys = try await accountQueryBuilder.roleQueryBuilder()
            .all(
                filter: .init(
                    field: .accountId,
                    operator: .equal,
                    value: account.id
                )
            )
            .map { $0.roleKey }
            .map { $0.toID() }

        let rolesQueryBuilder = User.Role.Query(db: db)
        let roleReferences =
            try await rolesQueryBuilder.all(
                filter: .init(
                    field: .key,
                    operator: .in,
                    value: accountRoleKeys
                )
            )
            .map {
                try $0.toReference()
            }

        return User.Account.Detail(
            id: account.id.toID(),
            email: account.email,
            roles: roleReferences
        )
    }

}
