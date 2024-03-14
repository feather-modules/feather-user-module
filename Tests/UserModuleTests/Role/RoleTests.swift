import CoreModuleInterface
import SystemModuleInterface
import UserModule
import UserModuleInterface
import XCTest

extension User.Role.Create {

    static func mock(
        _ i: Int = 1,
        permissionKeys: [ID<System.Permission>] = []
    ) -> User.Role.Create {
        .init(
            key: .init(rawValue: "key-\(i)"),
            name: "name-\(i)",
            notes: "notes-\(i)",
            permissionKeys: permissionKeys
        )
    }
}

final class RoleTests: TestCase {

    func testCreate() async throws {

        let detail = try await Module.role.create(
            User.Role.Create.mock()
        )

        XCTAssertEqual(detail.key.rawValue, "key-1")
    }

    func testCreatePermissions() async throws {

        let p = try await Module.system.permission.create(
            .init(
                key: .init(rawValue: "a.b.c"),
                name: "abc"
            )
        )
        let detail = try await Module.role.create(
            User.Role.Create.mock(permissionKeys: [p.key])
        )

        XCTAssertEqual(detail.permissions.count, 1)
        XCTAssertEqual(detail.permissions[0].key, p.key)
    }

    func testDetail() async throws {
        let detail = try await Module.role.create(
            User.Role.Create.mock()
        )

        let role = try await Module.role.get(key: detail.key)
        XCTAssertEqual(role.key, detail.key)
    }

    func testUpdate() async throws {
        let detail = try await Module.role.create(
            User.Role.Create.mock()
        )

        let role = try await Module.role.update(
            key: detail.key,
            User.Role.Update(
                key: detail.key,
                name: "name-2",
                notes: "notes-2",  // TODO: fix nil value issue in db layer
                permissionKeys: []
            )
        )
        XCTAssertEqual(role.key, detail.key)
        XCTAssertEqual(role.name, "name-2")
        XCTAssertEqual(role.notes, "notes-2")
    }

    func testPatch() async throws {
        let detail = try await Module.role.create(
            User.Role.Create.mock()
        )

        let role = try await Module.role.patch(
            key: detail.key,
            User.Role.Patch(
                key: detail.key,
                name: "name-2",
                notes: "notes-2"
            )
        )
        XCTAssertEqual(role.key, detail.key)
        XCTAssertEqual(role.name, "name-2")
        XCTAssertEqual(role.notes, "notes-2")
    }

    func testDelete() async throws {
        let detail = try await Module.role.create(
            User.Role.Create.mock()
        )

        try await Module.role.bulkDelete(
            keys: [detail.key]
        )

        let roles = try await Module.role.reference(
            keys: [
                detail.key
            ]
        )
        XCTAssertTrue(roles.isEmpty)
    }
}
