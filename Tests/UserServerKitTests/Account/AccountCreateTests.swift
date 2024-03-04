import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class AccountCreateTests: TestCase {

    func testValidCreate() async throws {
        let email = "user1@example.com"
        let token = try await getAuthToken()

        try await runSpec {
            POST("user/accounts")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserAccountCreate(
                    email: email,
                    password: "ChangeMe1",
                    roleKeys: []
                )
            )
            JSONResponse(
                type: Components.Schemas.UserAccountDetail.self
            ) { value in
                XCTAssertEqual(value.email, email)
            }
        }

        let list = try await sdk.auth(TestUser.root()) {
            try await sdk.listAccounts(.init())
        }

        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items[0].email, email)
    }

    func testCreateRoles() async throws {
        let role = try await sdk.auth(TestUser.root()) {
            try await sdk.createRole(
                .init(
                    key: .init("manager"),
                    name: "Account manager",
                    permissionKeys: []
                )
            )
        }

        let token = try await getAuthToken()

        try await runSpec {
            POST("user/accounts")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserAccountCreate(
                    email: "user1@example.com",
                    password: "password1",
                    roleKeys: [
                        role.key.rawValue
                    ]
                )
            )
            JSONResponse(
                type: Components.Schemas.UserAccountDetail.self
            ) { value in
                XCTAssertEqual(value.email, "user1@example.com")
                XCTAssertEqual(value.roles.count, 1)
                XCTAssertEqual(value.roles[0].key, role.key.rawValue)
            }
        }
    }
}
