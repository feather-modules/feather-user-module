//
//  File.swift
//
//
//  Created by Tibor Bodecs on 29/02/2024.
//

import FeatherKit
import UserInterfaceKit

struct TestUser {

    static func root(
        _ permissionKeys: [String]? = nil
    ) -> ACL.AuthenticatedUser {
        .init(
            accountId: "root",
            roleKeys: [
                "root"
            ],
            permissionKeys: permissionKeys ?? User.ACL.all
        )
    }

}
