//import CoreSDKInterface
//import UserSDK
//import UserSDKInterface
//import XCTest
//
//final class RoleCreateTests: TestCase {
//
//    func testValidCreate() async throws {
//
//        let key: ID<User.Role> = .init("manager")
//
//        let detail = try await self.sdk.createRole(
//            .init(
//                key: key,
//                name: "Manager role",
//                permissionKeys: []
//            )
//        )
//
//        XCTAssertEqual(detail.key, key)
//
//        let list = try await sdk.listRoles(.init())
//
//        XCTAssertEqual(list.count, 1)
//        XCTAssertEqual(list.items.count, 1)
//        XCTAssertEqual(list.items[0].key, key)
//
//    }
//
//    func testPermissionsCreate() async throws {
//
//        let key: ID<User.Role> = .init("manager")
//
//        let detail = try await self.sdk.createRole(
//            .init(
//                key: key,
//                name: "Manager role",
//                permissionKeys: []
//            )
//        )
//
//        XCTAssertEqual(detail.key, key)
//
//        let list = try await sdk.listRoles(.init())
//
//        XCTAssertEqual(list.count, 1)
//        XCTAssertEqual(list.items.count, 1)
//        XCTAssertEqual(list.items[0].key, key)
//
//    }
//}
