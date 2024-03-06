import CoreSDKInterface
import UserSDK
import UserSDKInterface
import XCTest

final class RoleCreateTests: TestCase {

    func testCreateUnauthorizedAccess() async throws {
        try await unauthorizedCheck {
            _ = try await self.sdk.createRole(
                .init(
                    key: .init("manager"),
                    name: "Manager role",
                    permissionKeys: []
                )
            )
        }
    }

    func testCreateForbiddenAccess() async throws {
        try await forbiddenCheck(
            User.Role.ACL.create.rawValue
        ) {
            try await self.sdk.auth(TestUser.root([])) {
                _ = try await self.sdk.createRole(
                    .init(
                        key: .init("manager"),
                        name: "Manager role",
                        permissionKeys: []
                    )
                )
            }
        }
    }

    func testValidCreate() async throws {
        try await sdk.auth(TestUser.root()) {
            let key: ID<User.Role> = .init("manager")

            let detail = try await self.sdk.createRole(
                .init(
                    key: key,
                    name: "Manager role",
                    permissionKeys: []
                )
            )

            XCTAssertEqual(detail.key, key)

            let list = try await sdk.listRoles(.init())

            XCTAssertEqual(list.count, 1)
            XCTAssertEqual(list.items.count, 1)
            XCTAssertEqual(list.items[0].key, key)
        }
    }

    func testPermissionsCreate() async throws {
        try await sdk.auth(TestUser.root()) {
            let key: ID<User.Role> = .init("manager")

            let detail = try await self.sdk.createRole(
                .init(
                    key: key,
                    name: "Manager role",
                    permissionKeys: []
                )
            )

            XCTAssertEqual(detail.key, key)

            let list = try await sdk.listRoles(.init())

            XCTAssertEqual(list.count, 1)
            XCTAssertEqual(list.items.count, 1)
            XCTAssertEqual(list.items[0].key, key)
        }
    }
}
