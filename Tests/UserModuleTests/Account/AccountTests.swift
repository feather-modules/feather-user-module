import FeatherModuleKit
import UserModule
import UserModuleKit
import XCTest

final class AccountTests: TestCase {

    func testCreate() async throws {
        let email = "user1@example.com"

        let detail = try await module.account.create(
            User.Account.Create(
                email: email,
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey",
                position: "position",
                publicEmail: "publicEmail",
                phone: "phone",
                web: "web",
                lat: 1.0,
                lon: 2.0,
                lastLocationUpdate: nil
            )
        )

        XCTAssertEqual(detail.email, email)
        XCTAssertEqual(detail.firstName, "firstName")
        XCTAssertEqual(detail.lastName, "lastName")
        XCTAssertEqual(detail.imageKey, "imageKey")
        XCTAssertEqual(detail.position, "position")
        XCTAssertEqual(detail.publicEmail, "publicemail")
        XCTAssertEqual(detail.phone, "phone")
        XCTAssertEqual(detail.web, "web")
        XCTAssertEqual(detail.lat, 1.0)
        XCTAssertEqual(detail.lon, 2.0)
        XCTAssertEqual(detail.lastLocationUpdate, nil)
    }

    func testRolesCreate() async throws {
        let email = "user1@example.com"

        let role = try await module.role.create(
            User.Role.Create(
                key: .init(rawValue: "manager"),
                name: "Account manager"
            )
        )

        let detail = try await module.account.create(
            User.Account.Create(
                email: email,
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey",
                position: "publicEmail",
                publicEmail: "publicEmail",
                phone: "phone",
                web: "web",
                lat: 1.0,
                lon: 2.0,
                lastLocationUpdate: nil,
                roleKeys: [
                    .init(rawValue: "manager")
                ]
            )
        )

        XCTAssertEqual(detail.roles.count, 1)
        XCTAssertEqual(detail.roles[0].key, role.key)
        XCTAssertEqual(detail.roles[0].name, role.name)
    }

    func testDetail() async throws {

        let email = "user1@example.com"

        let role = try await module.role.create(
            .init(
                key: .init(rawValue: "manager"),
                name: "Account manager",
                permissionKeys: []
            )
        )

        let account = try await module.account.create(
            .init(
                email: email,
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey",
                position: "position",
                publicEmail: "publicEmail",
                phone: "phone",
                web: "web",
                lat: 1.0,
                lon: 2.0,
                lastLocationUpdate: nil,
                roleKeys: [
                    .init(rawValue: "manager")
                ]
            )
        )

        let detail = try await module.account.require(account.id)

        XCTAssertEqual(detail.roles.count, 1)
        XCTAssertEqual(detail.roles[0].key, role.key)
        XCTAssertEqual(detail.roles[0].name, role.name)
        XCTAssertEqual(detail.firstName, "firstName")
        XCTAssertEqual(detail.lastName, "lastName")
        XCTAssertEqual(detail.imageKey, "imageKey")
        XCTAssertEqual(detail.position, "position")
        XCTAssertEqual(detail.publicEmail, "publicemail")
        XCTAssertEqual(detail.phone, "phone")
        XCTAssertEqual(detail.web, "web")
        XCTAssertEqual(detail.lat, 1.0)
        XCTAssertEqual(detail.lon, 2.0)
        XCTAssertEqual(detail.lastLocationUpdate, nil)
    }

    func testPatch() async throws {

        let email = "user1@example.com"

        let role1 = try await module.role.create(
            .init(
                key: .init(rawValue: "manager"),
                name: "Account manager",
                permissionKeys: []
            )
        )
        let role2 = try await module.role.create(
            .init(
                key: .init(rawValue: "editor"),
                name: "Account editor",
                permissionKeys: []
            )
        )

        let account = try await module.account.create(
            .init(
                email: email,
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey",
                position: "position",
                publicEmail: "publicEmail",
                phone: "phone",
                web: "web",
                lat: 1.0,
                lon: 2.0,
                lastLocationUpdate: nil,
                roleKeys: [role1.key]
            )
        )

        let detail = try await module.account.patch(
            account.id,
            .init(roleKeys: [role2.key])
        )

        XCTAssertEqual(detail.roles.count, 1)
        XCTAssertEqual(detail.roles[0].key, role2.key)
        XCTAssertEqual(detail.roles[0].name, role2.name)
        XCTAssertEqual(detail.firstName, "firstName")
        XCTAssertEqual(detail.lastName, "lastName")
        XCTAssertEqual(detail.imageKey, "imageKey")
        XCTAssertEqual(detail.position, "position")
        XCTAssertEqual(detail.publicEmail, "publicemail")
        XCTAssertEqual(detail.phone, "phone")
        XCTAssertEqual(detail.web, "web")
        XCTAssertEqual(detail.lat, 1.0)
        XCTAssertEqual(detail.lon, 2.0)
        XCTAssertEqual(detail.lastLocationUpdate, nil)
    }

    func testUpdate() async throws {

        let email = "user1@example.com"

        let role1 = try await module.role.create(
            .init(
                key: .init(rawValue: "manager"),
                name: "Account manager",
                permissionKeys: []
            )
        )
        let role2 = try await module.role.create(
            .init(
                key: .init(rawValue: "editor"),
                name: "Account editor",
                permissionKeys: []
            )
        )

        let account = try await module.account.create(
            .init(
                email: email,
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey",
                position: "position",
                publicEmail: "publicEmail",
                phone: "phone",
                web: "web",
                lat: 1.0,
                lon: 2.0,
                lastLocationUpdate: nil,
                roleKeys: [role1.key]
            )
        )

        let detail = try await module.account.update(
            account.id,
            .init(
                email: email,
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey",
                position: "position",
                publicEmail: "publicEmail",
                phone: "phone",
                web: "web",
                lat: 1.0,
                lon: 2.0,
                lastLocationUpdate: nil,
                roleKeys: [role2.key]
            )
        )

        XCTAssertEqual(detail.roles.count, 1)
        XCTAssertEqual(detail.roles[0].key, role2.key)
        XCTAssertEqual(detail.roles[0].name, role2.name)
        XCTAssertEqual(detail.firstName, "firstName")
        XCTAssertEqual(detail.lastName, "lastName")
        XCTAssertEqual(detail.imageKey, "imageKey")
        XCTAssertEqual(detail.position, "position")
        XCTAssertEqual(detail.publicEmail, "publicemail")
        XCTAssertEqual(detail.phone, "phone")
        XCTAssertEqual(detail.web, "web")
        XCTAssertEqual(detail.lat, 1.0)
        XCTAssertEqual(detail.lon, 2.0)
        XCTAssertEqual(detail.lastLocationUpdate, nil)
    }

}
