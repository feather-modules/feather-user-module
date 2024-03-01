import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class RoleGetTests: TestCase {

    func testSimpleDelete() async throws {
        let token = try await getAuthToken()

        let object = try await sdk.auth(TestUser.root()) {

            try await sdk.createRole(
                .init(
                    key: .init("key"),
                    name: "name",
                    notes: "notes",
                    permissionKeys: []
                )
            )
        }

        try await runSpec {
            GET("user/roles/\(object.key)")
            BearerToken(token)
            JSONResponse(
                type: Components.Schemas.UserRoleDetail.self
            ) { item in
                XCTAssertEqual(item.key, "key")
            }
        }
    }
}
