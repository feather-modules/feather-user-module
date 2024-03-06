//
//  File.swift
//
//
//  Created by Tibor Bodecs on 29/02/2024.
//

import CoreSDKInterface
import UserSDK
import UserSDKInterface
import XCTest

final class AccountDetailTests: TestCase {

    func testDetail() async throws {
        try await sdk.auth(TestUser.root()) {
            let email = "user1@example.com"

            let role = try await sdk.createRole(
                .init(
                    key: .init("manager"),
                    name: "Account manager",
                    permissionKeys: []
                )
            )

            let account = try await sdk.createAccount(
                .init(
                    email: email,
                    password: "ChangeMe1",
                    roleKeys: [
                        .init("manager")
                    ]
                )
            )

            let detail = try await sdk.getAccount(id: account.id)

            XCTAssertEqual(detail.roles.count, 1)
            XCTAssertEqual(detail.roles[0].key, role.key)
            XCTAssertEqual(detail.roles[0].name, role.name)
        }
    }

}
