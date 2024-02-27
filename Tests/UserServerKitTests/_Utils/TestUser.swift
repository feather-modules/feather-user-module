//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import FeatherKit
import UserInterfaceKit

struct TestUser {

    static func root() -> ACL.AuthenticatedUser {
        .init(
            accountId: "root",
            roleKeys: [
                "root"
            ],
            permissionKeys: [
                User.Account.ACL.list.rawValue,
                User.Account.ACL.get.rawValue,
                User.Account.ACL.create.rawValue,
                User.Account.ACL.update.rawValue,
                User.Account.ACL.delete.rawValue,

                User.Role.ACL.list.rawValue,
                User.Role.ACL.get.rawValue,
                User.Role.ACL.create.rawValue,
                User.Role.ACL.update.rawValue,
                User.Role.ACL.delete.rawValue,
                    // TODO: add other permission
            ]
        )
    }

}
