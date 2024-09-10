import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModule
import UserModuleKit
import XCTest

extension User.AccountInvitation.Create {
    static func mock(
        _ i: Int,
        _ key: ID<User.AccountInvitationType>
    ) -> User.AccountInvitation.Create {
        
        return .init(
            email: "test\(i)@test.com",
            invitationTypeKeys: [key]
        )
    }
}

final class AccountInvitationTests: TestCase {

    func testCreate() async throws {
        let invitationType = try await createTestData()
        let detail = try await module.accountInvitation.create(
            .mock(1, invitationType.key)
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
        let invitationType = try await createTestData()
        let _ = try await module.accountInvitation.create(
            .mock(1, invitationType.key)
        )
        do {
            _ = try await module.accountInvitation.create(
                .mock(1, invitationType.key)
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
        let invitationType = try await createTestData()
        let createdDetail = try await module.accountInvitation.create(
            .mock(1, invitationType.key)
        )
        let detail = try await module.accountInvitation.require(createdDetail.id)
        XCTAssertEqual(detail.id, createdDetail.id)
        XCTAssertEqual(detail.invitationTypes, createdDetail.invitationTypes)
    }

    func testList() async throws {
        let invitationType = try await createTestData()
        let _ = try await module.accountInvitation.create(
            .mock(1, invitationType.key)
        )
        let _ = try await module.accountInvitation.create(
            .mock(2, invitationType.key)
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
        let invitationType = try await createTestData()
        let detail = try await module.accountInvitation.create(
            .mock(1, invitationType.key)
        )
        _ = try await module.accountInvitation.bulkDelete(
            ids: [detail.id]
        )
    }
    
    private func createTestData() async throws -> User.AccountInvitationType.Detail {
        _ = try await module.role.create(
            .mock()
        )
        let typeDetail = try await module.accountInvitationType.create(
            .mock()
        )
        return typeDetail
    }

}
