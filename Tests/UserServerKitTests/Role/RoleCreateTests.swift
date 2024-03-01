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
}
