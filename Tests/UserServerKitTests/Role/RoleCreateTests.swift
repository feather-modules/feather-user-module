import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class RoleCreateTests: TestCase {

    func testValidCreate() async throws {
        let token = try await getAuthToken()

        try await runSpec {
            POST("user/roles")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserRoleCreate(
                    key: "key",
                    name: "name",
                    notes: "notes",
                    permissionKeys: []
                )
            )
            JSONResponse(
                type: Components.Schemas.UserRoleDetail.self
            ) { value in
                XCTAssertEqual(value.key, "key")
                XCTAssertEqual(value.name, "name")
                XCTAssertEqual(value.notes, "notes")
            }
        }

        let list = try await sdk.auth(TestUser.root()) {
            try await sdk.listRoles(.init(page: .init()))
        }

        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items[0].key.rawValue, "key")
    }

    func testCreatePermission() async throws {
        let permission = try await sdk.auth(TestUser.root()) {
            try await sdk.system.createPermission(
                .init(
                    key: .init("a.b.c"),
                    name: "abc"
                )
            )
        }

        let token = try await getAuthToken()

        try await runSpec {
            POST("user/roles")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserRoleCreate(
                    key: "foo",
                    name: "Foo",
                    permissionKeys: [
                        permission.key.rawValue
                    ]
                )
            )
            JSONResponse(
                type: Components.Schemas.UserRoleDetail.self
            ) { value in
                XCTAssertEqual(value.key, "foo")
                XCTAssertEqual(value.permissions.count, 1)
                XCTAssertEqual(
                    value.permissions[0].key,
                    permission.key.rawValue
                )
            }
        }
    }
}
