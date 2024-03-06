import CoreSDKInterface
import UserSDK
import UserSDKInterface
import XCTest

final class AccountCreateTests: TestCase {

    func testValidCreate() async throws {

        let email = "user1@example.com"

        let detail = try await sdk.createAccount(
            User.Account.Create(
                email: email,
                password: "ChangeMe1"
            )
        )

        XCTAssertEqual(detail.email, email)

        //        let list = try await sdk.listAccounts()
        //
        //        XCTAssertEqual(list.count, 1)
        //        XCTAssertEqual(list.items.count, 1)
        //        XCTAssertEqual(list.items[0].email, "user1@example.com")

    }

    func testRolesCreate() async throws {
        let email = "user1@example.com"

        //        let role = try await sdk.createRole(
        //            .init(
        //                key: .init(rawValue: "manager"),
        //                name: "Account manager",
        //                permissionKeys: []
        //            )
        //        )
        //
        //        let detail = try await sdk.createAccount(
        //            User.Account.Create(
        //                email: email,
        //                password: "ChangeMe1",
        //                roleKeys: [
        //                    .init(rawValue: "manager")
        //                ]
        //            )
        //        )
        //
        //        XCTAssertEqual(detail.roles.count, 1)
        //        XCTAssertEqual(detail.roles[0].key, role.key)
        //        XCTAssertEqual(detail.roles[0].name, role.name)
    }
}
