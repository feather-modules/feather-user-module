import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class AccountGetTests: TestCase {

    func testSimpleGet() async throws {
        let token = try await getAuthToken()

        let object = try await sdk.auth(TestUser.root()) {
            try await sdk.createAccount(
                .init(
                    email: "user1@example.com",
                    password: "password1"
                )
            )
        }

        try await runSpec {
            GET("user/accounts/\(object.id)")
            BearerToken(token)
            JSONResponse(
                type: Components.Schemas.UserAccountDetail.self
            ) { item in
                XCTAssertEqual(item.email, "user1@example.com")
            }
        }
    }
}
