//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import CoreInterfaceKit
import UserInterfaceKit

struct TestUser {

    static func root() -> ACL.AuthenticatedUser {
        .init(
            accountId: "root",
            roleKeys: [
                "root"
            ],
            permissionKeys: User.ACL.all + [
                "system.permission.create",
                "system.permission.get",
            ]  // TODO
        )
    }

}
