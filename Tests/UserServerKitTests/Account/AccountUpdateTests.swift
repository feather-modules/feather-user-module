import CoreInterfaceKit
import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class AccountUpdateTests: TestCase {

    func testSimpleUpdate() async throws {
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
            PUT("user/accounts/\(object.id)")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserAccountUpdate(
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
