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
        // TODO: role references
        return User.Account.Detail(
            id: account.id.toID(),
            email: account.email,
            roles: []
        )
    }

}
