import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class AccountListTests: TestCase {

    func testSimpleList() async throws {
        let token = try await getAuthToken()

        try await sdk.auth(TestUser.root()) {
            [
                try await sdk.createAccount(
                    .init(
                        email: "user1@example.com",
                        password: "password1",
                        roleKeys: []
                    )
                ),
                try await sdk.createAccount(
                    .init(
                        email: "user2@example.com",
                        password: "password2",
                        roleKeys: []
                    )
                ),
            ]
        }

        try await runSpec {
            GET("user/accounts")
            BearerToken(token)
            JSONResponse(
                type: Components.Schemas.UserAccountList.self
            ) { value in
                XCTAssertFalse(value.items.isEmpty)
                //                XCTAssertEqual(value.items[0].email, "user1@example.com")
                //                XCTAssertEqual(value.items[1].email, "user2@example.com")
            }
        }
    }
}
