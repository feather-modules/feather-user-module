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

struct ProfileController: UserProfileInterface {

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
        let db = try await components.database().connection()
        guard
            let account = try await User.Account.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: [acl.accountId]
                ),
                on: db
            )
        else {
            throw AccessControlError.unauthorized
        }
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
        let roles = try await user.role.reference(ids: roleKeys)
        return User.Account.Detail(
            id: account.id.toID(),
            email: account.email,
            roles: roles
        )
    }

}
