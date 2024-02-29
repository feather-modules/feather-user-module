import FeatherKit
import UserInterfaceKit
import UserKit
import XCTest

func XCTAssertThrowsAsync<E: Error>(
    _ expression: () async throws -> Void,
    _: E.Type,
    _ errorBlock: ((E) async throws -> Void)? = nil,
    _ message: String,
    file: StaticString = #file,
    line: UInt = #line
) async throws {
    do {
        _ = try await expression()
    }
    catch let error as E {
        try await errorBlock?(error)
    }
    catch {
        XCTFail(message, file: file, line: line)
    }
}

final class AccountCreateTests: TestCase {

    func testCreateUnauthorizedAccess() async throws {
        try await XCTAssertThrowsAsync(
            {
                _ = try await self.sdk.createAccount(
                    .init(
                        email: "user1@example.com",
                        password: "ChangeMe1"
                    )
                )
            },
            ACLError.self,
            { error in
                switch error {
                case .forbidden(_):
                    XCTFail("Should be an unauthorized state.")
                case .unauthorized(let state):
                    XCTAssertEqual(state, .any)
                }
            },
            "The call should fail with an access control error"
        )
    }

    func testCreateForbiddenAccess() async throws {

        try await XCTAssertThrowsAsync(
            {
                try await self.sdk.auth(TestUser.root([])) {
                    _ = try await self.sdk.createAccount(
                        .init(
                            email: "user1@example.com",
                            password: "ChangeMe1"
                        )
                    )
                }
            },
            ACLError.self,
            { error in
                switch error {
                case .forbidden(let state):
                    XCTAssertEqual(state.kind, .permission)
                    XCTAssertEqual(state.key, User.Account.ACL.create.rawValue)
                case .unauthorized(let state):
                    XCTFail("Should be a forbidden state.")
                }
            },
            "The call should fail with an access control error"
        )
    }

    func testValidCreate() async throws {
        try await sdk.auth(TestUser.root()) {
            let email = "user1@example.com"

            let detail = try await sdk.createAccount(
                .init(
                    email: email,
                    password: "ChangeMe1"
                )
            )

            XCTAssertEqual(detail.email, email)

            let list = try await sdk.listAccounts(.init())

            XCTAssertEqual(list.count, 1)
            XCTAssertEqual(list.items.count, 1)
            XCTAssertEqual(list.items[0].email, "user1@example.com")
        }
    }
}
