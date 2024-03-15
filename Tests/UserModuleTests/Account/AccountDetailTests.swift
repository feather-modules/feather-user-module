//
//  File.swift
//
//
//  Created by Tibor Bodecs on 29/02/2024.
//

import CoreModuleInterface
import UserModule
import UserModuleInterface
import XCTest

final class AccountDetailTests: TestCase {

    func testDetail() async throws {

        let email = "user1@example.com"

        let role = try await module.role.create(
            .init(
                key: .init(rawValue: "manager"),
                name: "Account manager",
                permissionKeys: []
            )
        )

        let account = try await module.account.create(
            .init(
                email: email,
                password: "ChangeMe1",
                roleKeys: [
                    .init(rawValue: "manager")
                ]
            )
        )

        let detail = try await module.account.get(id: account.id)

        XCTAssertEqual(detail.roles.count, 1)
        XCTAssertEqual(detail.roles[0].key, role.key)
        XCTAssertEqual(detail.roles[0].name, role.name)

    }

}
