import FeatherModuleKit
import UserModule
import UserModuleKit
import XCTest

final class AccountRoleTests: TestCase {

    func testCreate() async throws {
        let detail = try await module.accountRole.create(
            User.AccountRole.Create(
                accountId: .init(rawValue: "testAccount"),
                roleKey: .init(rawValue: "testRole")
            )
        )
        XCTAssertEqual(detail.accountId, .init(rawValue: "testAccount"))
        XCTAssertEqual(detail.roleKey, .init(rawValue: "testRole"))
    }

    func testDetail() async throws {

        let role = try await module.accountRole.create(
            User.AccountRole.Create(
                accountId: .init(rawValue: "testAccount"),
                roleKey: .init(rawValue: "testRole")
            )
        )

        let detail = try await module.accountRole.require(role.accountId)

        XCTAssertEqual(detail.accountId, role.accountId)
        XCTAssertEqual(detail.roleKey, role.roleKey)
    }

}
