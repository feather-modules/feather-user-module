import FeatherKit
import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class AccountPatchTests: TestCase {

    func testSimplePatch() async throws {
        let token = try await getAuthToken()

        let object = try await sdk.auth(TestUser.root()) {
            try await sdk.createAccount(
                .init(
                    email: "user1@example.com",
                    password: "password1",
                    roleKeys: []
                )
            )
        }

        try await runSpec {
            PATCH("user/accounts/\(object.id)")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserAccountPatch(
                    email: "user2@example.com",
                    password: "password2",
                    roleKeys: []
                )
            )
            JSONResponse(
                type: Components.Schemas.UserAccountDetail.self
            ) { value in
                XCTAssertEqual(value.email, "user2@example.com")
            }
        }
    }
}
