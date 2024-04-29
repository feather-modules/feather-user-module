import FeatherModuleKit
import UserModule
import UserModuleKit
import XCTest

final class PushTests: TestCase {

    func testCreate() async throws {
        let input = User.Push.Create(
            title: "title",
            message: "message",
            recipients: []
        )

        let detail = try await module.push.create(input)
        XCTAssertEqual(detail.title, input.title)
        XCTAssertEqual(detail.message, input.message)
    }

    func testDetail() async throws {
        let input = User.Push.Create(
            title: "title",
            message: "message",
            recipients: []
        )
        let detail = try await module.push.create(input)
        let savedDetail = try await module.push.get(detail.id)
        XCTAssertEqual(detail.title, savedDetail?.title)
        XCTAssertEqual(detail.message, savedDetail?.message)
    }

    func testList() async throws {
        let input = User.Push.Create(
            title: "title",
            message: "message",
            recipients: []
        )
        let _ = try await module.push.create(input)
        let _ = try await module.push.create(input)
        let list = try await module.push.list(
            User.Push.List.Query(
                search: nil,
                sort: .init(by: .title, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
    }

}
