import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import UserModule
import UserModuleKit
import XCTest

final class AccountGroupTests: TestCase {

    func testCreate() async throws {
        let groupDetail = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        let userDetail = try await module.account.create(
            User.Account.Create(
                email: "test@test.com",
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey"
            )
        )
        let detail = try await module.accountGroup.create(
            User.AccountGroup.Create(
                accountId: userDetail.id,
                groupId: groupDetail.id
            )
        )
        XCTAssertEqual(detail.accountId, userDetail.id)
        XCTAssertEqual(detail.groupId, groupDetail.id)
    }

    func testCreateUnique() async throws {
        let groupDetail = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        let userDetail = try await module.account.create(
            User.Account.Create(
                email: "test@test.com",
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey"
            )
        )

        _ = try await module.accountGroup.create(
            User.AccountGroup.Create(
                accountId: userDetail.id,
                groupId: groupDetail.id
            )
        )

        do {
            _ = try await module.accountGroup.create(
                User.AccountGroup.Create(
                    accountId: userDetail.id,
                    groupId: groupDetail.id
                )
            )
            XCTFail("Validation test should fail.")
        }
        catch let error as FeatherDatabase.Database.Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCreateMultipleGroups() async throws {
        let groupDetail = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        let groupDetail2 = try await module.group.create(
            User.Group.Create(
                name: "name2"
            )
        )
        let userDetail = try await module.account.create(
            User.Account.Create(
                email: "test@test.com",
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey"
            )
        )
        let detail = try await module.accountGroup.create(
            User.AccountGroup.Create(
                accountId: userDetail.id,
                groupId: groupDetail.id
            )
        )
        XCTAssertEqual(detail.accountId, userDetail.id)
        XCTAssertEqual(detail.groupId, groupDetail.id)

        let detail2 = try await module.accountGroup.create(
            User.AccountGroup.Create(
                accountId: userDetail.id,
                groupId: groupDetail2.id
            )
        )
        XCTAssertEqual(detail2.accountId, userDetail.id)
        XCTAssertEqual(detail2.groupId, groupDetail2.id)
    }

    func testUpdate() async throws {
        let groupDetail = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        let userDetail = try await module.account.create(
            User.Account.Create(
                email: "test@test.com",
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey"
            )
        )
        let detail = try await module.accountGroup.create(
            User.AccountGroup.Create(
                accountId: userDetail.id,
                groupId: groupDetail.id
            )
        )
        XCTAssertEqual(detail.accountId, userDetail.id)
        XCTAssertEqual(detail.groupId, groupDetail.id)

        let groupDetail2 = try await module.group.create(
            User.Group.Create(
                name: "name2"
            )
        )
        let updatedDetail = try await module.accountGroup.update(
            detail.accountId,
            User.AccountGroup.Update(
                accountId: userDetail.id,
                groupId: groupDetail2.id
            )
        )

        XCTAssertEqual(updatedDetail.accountId, userDetail.id)
        XCTAssertEqual(updatedDetail.groupId, groupDetail2.id)
    }

    func testDelete() async throws {
        let groupDetail = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        let userDetail = try await module.account.create(
            User.Account.Create(
                email: "test@test.com",
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey"
            )
        )
        let detail = try await module.accountGroup.create(
            User.AccountGroup.Create(
                accountId: userDetail.id,
                groupId: groupDetail.id
            )
        )
        _ = try await module.accountGroup.bulkDelete(ids: [detail.accountId])
        do {
            _ = try await module.accountGroup.require(detail.accountId)
            XCTFail("Validation test should fail.")
        }
        catch let error as ModuleError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

}
