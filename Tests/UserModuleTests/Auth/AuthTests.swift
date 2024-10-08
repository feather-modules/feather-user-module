import FeatherModuleKit
import SystemModule
import SystemModuleKit
import UserModule
import UserModuleKit
import XCTest

final class AuthTests: TestCase {

    func testBasicAuth() async throws {

        let email = "test@user.com"
        let password = "ChangeMe1"
        let roleKey: ID<User.Role> = .init(rawValue: "manager")
        let permissionKey: ID<System.Permission> = .init(rawValue: "a.b.c.")

        _ = try await module.system.permission.create(
            .init(
                key: permissionKey,
                name: "abc permission"
            )
        )

        _ = try await module.role.create(
            User.Role.Create(
                key: roleKey,
                name: "Manager role",
                permissionKeys: [
                    permissionKey
                ]
            )
        )

        _ = try await module.account.create(
            User.Account.Create(
                email: email,
                password: password,
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey",
                roleKeys: [
                    roleKey
                ]
            )
        )

        let auth = try await module.auth.auth(
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
