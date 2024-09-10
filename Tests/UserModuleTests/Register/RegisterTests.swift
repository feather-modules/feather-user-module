import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModule
import UserModuleKit
import XCTest

final class RegisterTests: TestCase {
 
    
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
