//import CoreSDKInterface
//import SystemSDKInterface
//import SystemSDK
//import UserSDK
//import UserSDKInterface
//import XCTest
//
//final class AuthTests: TestCase {
//
//    func testBasicAuth() async throws {
//
//        let email = "test@user.com"
//        let password = "ChangeMe1"
//        let roleKey: ID<User.Role> = .init("manager")
//        let permissionKey: ID<System.Permission> = .init("a.b.c.")
//
//        _ = try await sdk.system.createPermission(
//            .init(
//                key: permissionKey,
//                name: "abc permission"
//            )
//        )
//
//        _ = try await sdk.createRole(
//            .init(
//                key: roleKey,
//                name: "Manager role",
//                permissionKeys: [
//                    permissionKey
//                ]
//            )
//        )
//
//        _ = try await sdk.createAccount(
//            .init(
//                email: email,
//                password: password,
//                roleKeys: [
//                    roleKey
//                ]
//            )
//        )
//
//        let auth = try await sdk.auth(
//            .init(
//                email: email,
//                password: password
//            )
//        )
//
//        XCTAssertEqual(auth.account.roles.count, 1)
//        XCTAssertEqual(auth.account.roles[0].key, roleKey)
//
//        XCTAssertEqual(auth.permissions.count, 1)
//        XCTAssertEqual(auth.permissions[0], permissionKey)
//    }
//
//}
