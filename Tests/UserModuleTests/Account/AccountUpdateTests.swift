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

final class AccountUpdateTests: TestCase {

    func testUpdate() async throws {

        let email = "user1@example.com"

        let role1 = try await Module.role.create(
            .init(
                key: .init(rawValue: "manager"),
                name: "Account manager",
                permissionKeys: []
            )
        )
        let role2 = try await Module.role.create(
            .init(
                key: .init(rawValue: "editor"),
                name: "Account editor",
                permissionKeys: []
            )
        )

        let account = try await Module.account.create(
            .init(
                email: email,
                password: "ChangeMe1",
                roleKeys: [role1.key]
            )
        )

        let detail = try await Module.account.update(
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
