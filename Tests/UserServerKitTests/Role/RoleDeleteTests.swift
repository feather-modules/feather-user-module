import FeatherOpenAPISpec
import UserKit
import UserOpenAPIRuntimeKit
import UserServerKit
import XCTest

final class RoleDeleteTests: TestCase {

    func testSimpleDelete() async throws {
        let token = try await getAuthToken()

        let objects = try await sdk.auth(TestUser.root()) {
            [
                try await sdk.createRole(
                    .init(
                        key: .init("key1"),
                        name: "name",
                        notes: "notes"
                    )
                ),
                try await sdk.createRole(
                    .init(
                        key: .init("key2"),
                        name: "name",
                        notes: "notes"
                    )
                ),
            ]
        }

        try await runSpec {
            DELETE("user/roles")
            BearerToken(token)
            JSONBody(
                [
                    objects[0].key
                ]
            )
            Expect(.noContent)
        }

        //        let list = try await sdk.auth(TestUser.root()) {
        //            try await sdk.listUserRoles(.init(page: .init()))
        //        }
        //        XCTAssertEqual(list.count, 1)
        //        XCTAssertEqual(list.items[0].key.rawValue, "key2")
    }

    func testBulkDelete() async throws {
        let token = try await getAuthToken()

        let objects = try await sdk.auth(TestUser.root()) {
            [
                try await sdk.createRole(
                    .init(
                        key: .init("key1"),
                        name: "name",
                        notes: "notes"
                    )
                ),
                try await sdk.createRole(
                    .init(
                        key: .init("key2"),
                        name: "name",
                        notes: "notes"
                    )
                ),
            ]
        }

        try await runSpec {
            DELETE("user/roles")
            BearerToken(token)
            JSONBody(
                [
                    objects[0].key,
                    objects[1].key,
                ]
            )
            Expect(.noContent)
        }

        //        let list = try await sdk.auth(TestUser.root()) {
        //            try await sdk.listUserRoles(.init(page: .init()))
        //        }
        //        XCTAssertTrue(list.items.isEmpty)
    }
}
