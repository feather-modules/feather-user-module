import CoreInterfaceKit
import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class RolePatchTests: TestCase {

    func testSimplePatch() async throws {

        let object = try await sdk.auth(TestUser.root()) {

            try await sdk.createRole(
                .init(
                    key: .init("key1"),
                    name: "name1",
                    notes: "notes1",
                    permissionKeys: []
                )
            )
        }

        let token = try await getAuthToken()
        try await runSpec {
            PATCH("user/roles/\(object.key)")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserRolePatch(
                    key: "key2",
                    name: "name2",
                    notes: "notes2"
                )
            )
            JSONResponse(
                type: Components.Schemas.UserRoleDetail.self
            ) { value in
                XCTAssertEqual(value.key, "key2")
                XCTAssertEqual(value.name, "name2")
                XCTAssertEqual(value.notes, "notes2")
            }
        }
    }

    func testPermissionPatch() async throws {

        let permission = try await sdk.auth(TestUser.root()) {
            try await sdk.system.createPermission(
                .init(
                    key: .init("a.b.c"),
                    name: "abc"
                )
            )
        }

        let object = try await sdk.auth(TestUser.root()) {

            try await sdk.createRole(
                .init(
                    key: .init("key1"),
                    name: "name1",
                    notes: "notes1",
                    permissionKeys: []
                )
            )
        }

        let token = try await getAuthToken()
        try await runSpec {
            PATCH("user/roles/\(object.key)")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserRolePatch(
                    key: "key2",
                    name: "name2",
                    notes: "notes2",
                    permissionKeys: [
                        permission.key.rawValue
                    ]
                )
            )
            JSONResponse(
                type: Components.Schemas.UserRoleDetail.self
            ) { value in
                XCTAssertEqual(value.key, "key2")
                XCTAssertEqual(value.name, "name2")
                XCTAssertEqual(value.notes, "notes2")
                XCTAssertEqual(value.permissions.count, 1)
                XCTAssertEqual(
                    value.permissions[0].key,
                    permission.key.rawValue
                )
            }
        }
    }
}
