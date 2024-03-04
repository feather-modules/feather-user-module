//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreInterfaceKit
import FeatherComponent
import Logging
import UserInterfaceKit

extension UserSDK {

    public func getMyAccount(

        ) async throws -> User.Account.Detail
    {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)

        let db = try await components.relationalDatabase().connection()
        let qb = User.Account.Query(db: db)

        guard
            let account = try await qb.firstBy(key: .id, value: user.accountId)
        else {
            throw UserSDKError.unknown
        }
        return .init(
            id: .init(user.accountId),
            email: account.email,
            roles: []  // TODO
        )
    }

}
