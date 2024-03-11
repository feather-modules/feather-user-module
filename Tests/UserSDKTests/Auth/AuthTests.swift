import CoreSDKInterface
import SystemSDK
import SystemSDKInterface
import UserSDK
import UserSDKInterface
import XCTest

final class AuthTests: TestCase {

    func testBasicAuth() async throws {

        let email = "test@user.com"
        let password = "ChangeMe1"
        let roleKey: ID<User.Role> = .init(rawValue: "manager")
        let permissionKey: ID<System.Permission> = .init(rawValue: "a.b.c.")

        _ = try await sdk.system.createPermission(
            System.Permission.Create(
                key: permissionKey,
                name: "abc permission"
            )
        )

        _ = try await sdk.createRole(
            User.Role.Create(
                key: roleKey,
                name: "Manager role",
                permissionKeys: [
                    permissionKey
                ]
            )
        )

        _ = try await sdk.createAccount(
            User.Account.Create(
                email: email,
                password: password,
                roleKeys: [
                    roleKey
                ]
            )
        )

        let auth = try await sdk.auth(
            User.Auth.Request(
                email: email,
                password: password
            )
        )

        XCTAssertEqual(auth.account.roles.count, 1)
        XCTAssertEqual(auth.account.roles[0].key, roleKey)

        XCTAssertEqual(auth.permissions.count, 1)
        XCTAssertEqual(auth.permissions[0], permissionKey)
    }

}
