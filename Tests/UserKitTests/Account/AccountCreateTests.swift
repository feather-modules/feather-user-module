import CoreInterfaceKit
import UserInterfaceKit
import UserKit
import XCTest

final class AccountCreateTests: TestCase {

    func testCreateUnauthorizedAccess() async throws {
        try await unauthorizedCheck {
            _ = try await self.sdk.createAccount(
                .init(
                    email: "user1@example.com",
                    password: "ChangeMe1"
                )
            )
        }
    }

    func testCreateForbiddenAccess() async throws {
        try await forbiddenCheck(
            User.Account.ACL.create.rawValue
        ) {
            try await self.sdk.auth(TestUser.root([])) {
                _ = try await self.sdk.createAccount(
                    .init(
                        email: "user1@example.com",
                        password: "ChangeMe1"
                    )
                )
            }
        }
    }

    func testValidCreate() async throws {
        try await sdk.auth(TestUser.root()) {
            let email = "user1@example.com"

            let detail = try await sdk.createAccount(
                .init(
                    email: email,
                    password: "ChangeMe1"
                )
            )

            XCTAssertEqual(detail.email, email)

            let list = try await sdk.listAccounts(.init())

            XCTAssertEqual(list.count, 1)
            XCTAssertEqual(list.items.count, 1)
            XCTAssertEqual(list.items[0].email, "user1@example.com")
        }
    }

    func testRolesCreate() async throws {
        try await sdk.auth(TestUser.root()) {
            let email = "user1@example.com"

            let role = try await sdk.createRole(
                .init(
                    key: .init("manager"),
                    name: "Account manager",
                    permissionKeys: []
                )
            )

            let detail = try await sdk.createAccount(
                .init(
                    email: email,
                    password: "ChangeMe1",
                    roleKeys: [
                        .init("manager")
                    ]
                )
            )

            XCTAssertEqual(detail.roles.count, 1)
            XCTAssertEqual(detail.roles[0].key, role.key)
            XCTAssertEqual(detail.roles[0].name, role.name)
        }
    }
}
