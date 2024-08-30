import FeatherModuleKit
import UserModule
import UserModuleKit
import XCTest
import Foundation

final class ProfileTests: TestCase {
    
    func testList() async throws {
        _ = try await createProfile(1)
        _ = try await createProfile(2)
        
        let list = try await module.profile.list(
            .init(
                search: nil,
                sort: .init(by: .firstName, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
    }
    
    func testDetail() async throws {
        let profile = try await createProfile()
        
        let saved = try await module.profile.require(profile.accountId)
        XCTAssertEqual(saved.accountId, profile.accountId)
        XCTAssertEqual(saved.firstName, profile.firstName)
        XCTAssertEqual(saved.lastName, profile.lastName)
        XCTAssertEqual(saved.imageKey, profile.imageKey)
        XCTAssertEqual(saved.position, profile.position)
        XCTAssertEqual(saved.publicEmail, profile.publicEmail)
        XCTAssertEqual(saved.phone, profile.phone)
        XCTAssertEqual(saved.web, profile.web)
        XCTAssertEqual(saved.lat, profile.lat)
        XCTAssertEqual(saved.lon, profile.lon)
        XCTAssertEqual(saved.lastLocationUpdate, profile.lastLocationUpdate)

    }
    
    func testPatch() async throws {
        let profile = try await createProfile()

        let patched = try await module.profile.patch(
            profile.accountId,
            .init(
                firstName: "newFirstName",
                position: "newPosition"
            )
        )
        XCTAssertEqual(patched.accountId, profile.accountId)
        XCTAssertEqual(patched.firstName, "newFirstName")
        XCTAssertEqual(patched.position, "newPosition")
    }

    func testUpdate() async throws {
        let profile = try await createProfile()
        
        let updated = try await module.profile.update(
            profile.accountId,
            .init(
                firstName: "newFirstName",
                lastName: profile.lastName,
                imageKey: profile.imageKey,
                position: "newPosition",
                publicEmail: profile.publicEmail,
                phone: profile.phone,
                web: profile.web,
                lat: 3.0,
                lon: profile.lon,
                lastLocationUpdate: profile.lastLocationUpdate
            )
        )
        
        XCTAssertEqual(updated.accountId, profile.accountId)
        XCTAssertEqual(updated.firstName, "newFirstName")
        XCTAssertEqual(updated.lastName, profile.lastName)
        XCTAssertEqual(updated.imageKey, profile.imageKey)
        XCTAssertEqual(updated.position, "newPosition")
        XCTAssertEqual(updated.publicEmail, profile.publicEmail)
        XCTAssertEqual(updated.phone, profile.phone)
        XCTAssertEqual(updated.web, profile.web)
        XCTAssertEqual(updated.lat, 3.0)
        XCTAssertEqual(updated.lon, profile.lon)
        XCTAssertEqual(updated.lastLocationUpdate, profile.lastLocationUpdate)
    }
    
    private func createProfile(accountId: ID<User.Account>) async throws -> User.Profile.Detail{
        try await module.profile.create(
            User.Profile.Create(
                accountId: accountId,
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey",
                position: "position",
                publicEmail: "public@email.com",
                phone: "345345345",
                web: "web",
                lat: 1.0,
                lon: 2.0,
                lastLocationUpdate: Date()
            )
        )
    }
    
    private func createProfile(_ number: Int = 1) async throws -> User.Profile.Detail{
        let detail = try await module.account.create(
            User.Account.Create(
                email: "user\(number)@example.com",
                password: "ChangeMe1"
            )
        )
        return try await module.profile.require(detail.id)
    }
    
    
}
