//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreSDKInterface
import FeatherACL
import FeatherComponent
import Logging
import UserSDKInterface

extension UserSDK {

    public func getMyAccount() async throws -> UserAccountDetail {
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
            roleReferences: []
        )
    }

}
