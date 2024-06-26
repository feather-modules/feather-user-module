import FeatherModuleKit
import UserModule
import UserModuleKit
import XCTest

final class PushTokenTests: TestCase {

    func testCreate() async throws {
        let model = User.PushToken.Create(
            accountId: .init(rawValue: "accountKey"),
            platform: User.PushToken.Platform.android,
            token: .generateToken()
        )

        let detail = try await module.pushToken.create(model)
        XCTAssertEqual(detail.accountId, model.accountId)
        XCTAssertEqual(detail.platform, model.platform)
        XCTAssertEqual(detail.token, model.token)
    }

    func testUpdate() async throws {
        let model = User.PushToken.Create(
            accountId: .init(rawValue: "accountKey"),
            platform: User.PushToken.Platform.android,
            token: .generateToken()
        )

        let detail = try await module.pushToken.create(model)
        let updatedModel = User.PushToken.Update(
            token: .generateToken()
        )

        let updatedDetail = try await module.pushToken.update(
            detail.accountId,
            updatedModel
        )
        XCTAssertEqual(detail.accountId, updatedDetail.accountId)
        XCTAssertEqual(detail.platform, updatedDetail.platform)
        XCTAssertNotEqual(detail.token, updatedDetail.token)
    }

    func testDelete() async throws {
        let model = User.PushToken.Create(
            accountId: .init(rawValue: "accountKey"),
            platform: User.PushToken.Platform.android,
            token: .generateToken()
        )
        let _ = try await module.pushToken.create(model)
        let detail = try await module.pushToken.get(model.accountId)
        XCTAssertEqual(model.accountId, detail?.accountId)
        XCTAssertEqual(model.platform, detail?.platform)
        XCTAssertEqual(model.token, detail?.token)

        let _ = try await module.pushToken.bulkDelete(ids: [detail!.accountId])
        let deletedDetail = try await module.pushToken.get(
            detail!.accountId
        )
        XCTAssertEqual(deletedDetail, nil)
    }

}
