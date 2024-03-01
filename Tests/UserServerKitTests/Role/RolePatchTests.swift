import CoreInterfaceKit
import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class RolePatchTests: TestCase {

    func testSimplePatch() async throws {
        let token = try await getAuthToken()

        let object = try await sdk.auth(TestUser.root()) {

            try await sdk.createRole(
                .init(
                    key: .init("key1"),
                    name: "name1",
                    notes: "notes1"
                )
            )
        }

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
}
