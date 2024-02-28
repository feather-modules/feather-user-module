import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class AccountDeleteTests: TestCase {

    func testSimpleDelete() async throws {
        let token = try await getAuthToken()

        let objects = try await sdk.auth(TestUser.root()) {
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
            DELETE("user/accounts")
            BearerToken(token)
            JSONBody(
                [
                    objects[0].id
                ]
            )
            Expect(.noContent)
        }

        //        let list = try await sdk.auth(TestUser.root()) {
        //            try await sdk.listUserAccounts(.init(page: .init()))
        //        }
        //
        //        XCTAssertEqual(list.count, 1)
        //        XCTAssertEqual(list.items[0].email, "user2@example.com")
    }

    func testBulkDelete() async throws {
        let token = try await getAuthToken()

        let objects = try await sdk.auth(TestUser.root()) {
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
            DELETE("user/accounts")
            BearerToken(token)
            JSONBody(
                [
                    objects[0].id,
                    objects[1].id,
                ]
            )
            Expect(.noContent)
        }

        //        let list = try await sdk.auth(TestUser.root()) {
        //            try await sdk.listUserAccounts(.init(page: .init()))
        //        }
        //
        //        XCTAssertTrue(list.items.isEmpty)
    }
}
