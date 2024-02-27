import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class AccountCreateTests: TestCase {

    func testValidCreate() async throws {
        let token = try await getAuthToken()

        try await runSpec {
            POST("user/accounts")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserAccountCreate(
                    email: "user1@example.com",
                    password: "password1"
                )
            )
            JSONResponse(
                type: Components.Schemas.UserAccountDetail.self
            ) { value in
                XCTAssertEqual(value.email, "user1@example.com")
            }
        }

        //        let list = try await sdk.auth(TestUser.root()) {
        //            try await sdk.listUserAccounts(.init(page: .init()))
        //        }
        //
        //        XCTAssertEqual(list.count, 1)
        //        XCTAssertEqual(list.items[0].email, "user1@example.com")
    }
}
