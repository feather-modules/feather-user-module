import CoreSDKInterface
import UserSDK
import UserSDKInterface
import XCTest

final class AccountCreateTests: TestCase {

    func testCreate() async throws {
        let email = "user1@example.com"

        let detail = try await sdk.account.create(
            User.Account.Create(
                email: email,
                password: "ChangeMe1"
            )
        )

        XCTAssertEqual(detail.email, email)
    }

    func testRolesCreate() async throws {
        let email = "user1@example.com"

        let role = try await sdk.role.create(
            User.Role.Create(
                key: .init(rawValue: "manager"),
                name: "Account manager"
            )
        )

        let detail = try await sdk.account.create(
            User.Account.Create(
                email: email,
                password: "ChangeMe1",
                roleKeys: [
                    .init(rawValue: "manager")
                ]
            )
        )

        XCTAssertEqual(detail.roles.count, 1)
        XCTAssertEqual(detail.roles[0].key, role.key)
        XCTAssertEqual(detail.roles[0].name, role.name)
    }
}
