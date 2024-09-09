import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModule
import UserModuleKit
import XCTest

extension User.AccountInvitationType.Create {

    static func mock(
        _ i: Int = 1
    ) -> User.AccountInvitationType.Create {
        .init(
            key: .init(rawValue: "key\(i)"),
            title: "title\(i)"
        )
    }
}

final class AccountInvitationTypeTests: TestCase {

    func testCreate() async throws {
        let detail = try await module.accountInvitationType.create(
            .mock()
        )
        XCTAssertTrue(detail.title == "title1")
    }

    func testList() async throws {
        let _ = try await module.accountInvitationType.create(
            .mock(1)
        )
        let _ = try await module.accountInvitationType.create(
            .mock(2)
        )

        let list = try await module.accountInvitationType.list(
            User.AccountInvitationType.List.Query(
                search: nil,
                sort: .init(by: .title, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
    }

}
