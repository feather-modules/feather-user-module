import CoreInterfaceKit
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

    func testRolePatch() async throws {
        let role1 = try await sdk.auth(TestUser.root()) {
            try await sdk.createRole(
                .init(
                    key: .init("manager"),
                    name: "Account manager",
                    permissionKeys: []
                )
            )
        }
        let role2 = try await sdk.auth(TestUser.root()) {
            try await sdk.createRole(
                .init(
                    key: .init("editor"),
                    name: "Account editor",
                    permissionKeys: []
                )
            )
        }

        let object = try await sdk.auth(TestUser.root()) {
            try await sdk.createAccount(
                .init(
                    email: "user1@example.com",
                    password: "password1",
                    roleKeys: [
                        role1.key
                    ]
                )
            )
        }

        let token = try await getAuthToken()
        try await runSpec {
            PATCH("user/accounts/\(object.id)")
            BearerToken(token)
            JSONBody(
                Components.Schemas.UserAccountPatch(
                    email: "user2@example.com",
                    password: "password2",
                    roleKeys: [
                        role2.key.rawValue
                    ]
                )
            )
            JSONResponse(
                type: Components.Schemas.UserAccountDetail.self
            ) { value in
                XCTAssertEqual(value.email, "user2@example.com")
                XCTAssertEqual(value.roles.count, 1)
                XCTAssertEqual(value.roles[0].key, role2.key.rawValue)
            }
        }
    }
}
