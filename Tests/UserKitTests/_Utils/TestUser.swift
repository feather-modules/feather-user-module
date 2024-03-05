//
//  File.swift
//
//
//  Created by Tibor Bodecs on 29/02/2024.
//

import CoreInterfaceKit
import SystemInterfaceKit
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
            permissionKeys: permissionKeys ?? (User.ACL.all + [
                System.Permission.ACL.list.rawValue,
                System.Permission.ACL.get.rawValue,
                System.Permission.ACL.create.rawValue,
                System.Permission.ACL.update.rawValue,
                System.Permission.ACL.delete.rawValue,
            ])
        )
    }

}
