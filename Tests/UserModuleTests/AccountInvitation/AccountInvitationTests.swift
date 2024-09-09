import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModule
import UserModuleKit
import XCTest

extension User.AccountInvitation.Create {
    static func mock(
        _ i: Int = 1
    ) -> User.AccountInvitation.Create {
        .init(
            email: "test\(i)@test.com",
            invitationTypeKeys: []
        )
    }
}

final class AccountInvitationTests: TestCase {

    func testCreate() async throws {
        let detail = try await module.accountInvitation.create(
            .mock()
        )
        XCTAssertEqual(detail.email, "test1@test.com")
    }

    func testCreateInvalid() async throws {
        do {
            _ = try await module.accountInvitation.create(
                .init(
                    email: "test@test",
                    invitationTypeKeys: []
                )
            )
            XCTFail("Validation test should fail with email validation.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
            let keys = error.failures.map(\.key).sorted()
            XCTAssertEqual(keys, ["email"])
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCreateUnique() async throws {
        let _ = try await module.accountInvitation.create(
            .mock()
        )
        do {
            _ = try await module.accountInvitation.create(
                .mock()
            )
            XCTFail("Validation test should fail with Database.Error.")
        }
        catch let error as Database.Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testDetail() async throws {
        let createdDetail = try await module.accountInvitation.create(
            .mock()
        )
        let detail = try await module.accountInvitation.require(createdDetail.id)
        XCTAssertEqual(detail.id, createdDetail.id)
    }

    func testList() async throws {
        let _ = try await module.accountInvitation.create(
            .mock(1)
        )
        let _ = try await module.accountInvitation.create(
            .mock(2)
        )

        let list = try await module.accountInvitation.list(
            User.AccountInvitation.List.Query(
                search: nil,
                sort: .init(by: .email, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
    }

    func testDelete() async throws {
        let detail = try await module.accountInvitation.create(
            .mock()
        )
        try await module.accountInvitation.bulkDelete(
            ids: [detail.id]
        )
    }

}
