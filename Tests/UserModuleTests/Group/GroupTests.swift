import FeatherModuleKit
import UserModule
import UserModuleKit
import FeatherValidation
import XCTest

final class GroupTests: TestCase {

    func testCreate() async throws {
        let detail = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        XCTAssertEqual(detail.name, "name")
    }
    
    func testCreateNotUniqueName() async throws {
        _ = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        do {
            _ = try await module.group.create(
                User.Group.Create(
                    name: "name"
                )
            )
            XCTFail("Validation test should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
            let keys = error.failures.map(\.key).sorted()
            XCTAssertEqual(keys, ["name"])
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testDetail() async throws {
        let createDetail = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        let detail = try await module.group.require(createDetail.id)
        XCTAssertEqual(detail.name, createDetail.name)
    }

    func testUpdate() async throws {
        let detail = try await module.group.create(
            User.Group.Create(
                name: "name"
            )
        )
        let updated = try await module.group.update(
            detail.id,
            .init(
                name: "new_name"
            )
        )
        XCTAssertEqual(updated.name, "new_name")
    }
    
    func testDelete() async throws {
        _ = try await module.group.create(
            User.Group.Create(
                name: "name1"
            )
        )
        let second = try await module.group.create(
            User.Group.Create(
                name: "name2"
            )
        )
        let list = try await module.group.list(
            User.Group.List.Query(
                search: nil,
                sort: .init(by: .name, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
        _ = try await module.group.bulkDelete(ids: [second.id])
        
        let list2 = try await module.group.list(
            User.Group.List.Query(
                search: nil,
                sort: .init(by: .name, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list2.count == 1)
    }
    
    func testList() async throws {
        _ = try await module.group.create(
            User.Group.Create(
                name: "name1"
            )
        )
        _ = try await module.group.create(
            User.Group.Create(
                name: "name2"
            )
        )
        let list = try await module.group.list(
            User.Group.List.Query(
                search: nil,
                sort: .init(by: .name, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
    }
    
    func testListWithUsers() async throws {
        
        
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
        
        let userDetail2 = try await module.account.create(
            User.Account.Create(
                email: "test2@test.com",
                password: "ChangeMe1",
                firstName: "firstName2",
                lastName: "lastName2",
                imageKey: "imageKey2"
            )
        )
        _ = try await module.accountGroup.create(
            User.AccountGroup.Create(
                accountId: userDetail2.id,
                groupId: groupDetail.id
            )
        )
        
        let list = try await module.group.listUsers(
            groupDetail.id,
            User.Account.List.Query(
                search: nil,
                sort: .init(by: .firstName, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
        XCTAssertTrue(list.items[0].account.firstName == userDetail.firstName)
        XCTAssertTrue(list.items[1].account.firstName == userDetail2.firstName)
    }

}
