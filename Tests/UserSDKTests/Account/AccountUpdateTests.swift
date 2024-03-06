//
//  File.swift
//
//
//  Created by Tibor Bodecs on 29/02/2024.
//

import CoreSDKInterface
import UserSDKInterface
import UserSDK
import XCTest

final class AccountUpdateTests: TestCase {

    func testUpdate() async throws {
        try await sdk.auth(TestUser.root()) {
            let email = "user1@example.com"

            let role1 = try await sdk.createRole(
                .init(
                    key: .init("manager"),
                    name: "Account manager",
                    permissionKeys: []
                )
            )
            let role2 = try await sdk.createRole(
                .init(
                    key: .init("editor"),
                    name: "Account editor",
                    permissionKeys: []
                )
            )

            let account = try await sdk.createAccount(
                .init(
                    email: email,
                    password: "ChangeMe1",
                    roleKeys: [role1.key]
                )
            )

            let detail = try await sdk.updateAccount(
                id: account.id,
                .init(
                    email: email,
                    roleKeys: [role2.key]
                )
            )

            XCTAssertEqual(detail.roles.count, 1)
            XCTAssertEqual(detail.roles[0].key, role2.key)
            XCTAssertEqual(detail.roles[0].name, role2.name)
        }
    }

}
