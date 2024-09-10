import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModule
import UserModuleKit
import XCTest

final class RegisterTests: TestCase {
    
    func testRegisterInvalidtoken() async throws {
        let email = "test@test.com"
        let input = User.Account.Create(
            email: email,
            password: "ChangeMe1",
            firstName: "firstName",
            lastName: "lastName",
            imageKey: "imageKey"
        )
        
        do {
            _ = try await module.register.register(invitationToken: "invalidToken", input)
            XCTFail("Validation test should fail with User.Error.")
        }
        catch let error as User.Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 3"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
 
    func testRegisterNoRole() async throws {
    
        let invitationDetail = try await module.accountInvitation.create(
            .mock(1, .init(rawValue: "wrongRoleKey"))
        )
        
        let email = "test@test.com"
        let input = User.Account.Create(
            email: email,
            password: "ChangeMe1",
            firstName: "firstName",
            lastName: "lastName",
            imageKey: "imageKey"
        )
        
        do {
            _ = try await module.register.register(invitationToken: invitationDetail.token, input)
            XCTFail("Validation test should fail with User.Error.")
        }
        catch let error as User.Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 3"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    
    func testRegister() async throws {
        
        _ = try await module.role.create(
            .mock()
        )
        let invitationType = try await module.accountInvitationType.create(
            .mock()
        )
        let invitationDetail = try await module.accountInvitation.create(
            .mock(1, invitationType.key)
        )
        
        let email = "test@test.com"
        let input = User.Account.Create(
            email: email,
            password: "ChangeMe1",
            firstName: "firstName",
            lastName: "lastName",
            imageKey: "imageKey"
        )
        
        let authResponse = try await module.register.register(invitationToken: invitationDetail.token, input)
        XCTAssertEqual(authResponse.account.email, email)
        XCTAssertEqual(authResponse.account.roles.count, 1)
    }
    
    
}
