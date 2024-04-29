import Bcrypt
import FeatherModuleKit
import FeatherValidation
import UserModule
import UserModuleKit
import FeatherDatabase
import XCTest

final class PasswordTests: TestCase {
    
    func testSetPassword_InvalidToken() async throws {
        let token: String = .generateToken()
        let input = User.Password.Set(password: "password")
        do {
            _ = try await module.password.set(token: token, input)
            XCTFail("Validation test should fail with User.Error.")
        }
        catch let error as User.Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 4"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetPassword_TokenExpiration() async throws {
        let token: String = .generateToken()
        let db = try await components.database().connection()
        let newPasswordReset = User.AccountPasswordReset.Model(
            accountId: .init(rawValue: "accountId"),
            token: token,
            expiration: Calendar.current.date(byAdding: .hour, value: -24, to: Date())!
        )
        try await User.AccountPasswordReset.Query.insert(
            newPasswordReset,
            on: db
        )
        
        let input = User.Password.Set(password: "password")
        do {
            _ = try await module.password.set(token: token, input)
            XCTFail("Validation test should fail with User.Error.")
        }
        catch let error as User.Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 4"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetPassword_PasswordInvalid() async throws {
        let token: String = .generateToken()
        let db = try await components.database().connection()
        let newPasswordReset = User.AccountPasswordReset.Model(
            accountId: .init(rawValue: "accountId"),
            token: token,
            expiration: Date().addingTimeInterval(86_400)
        )
        try await User.AccountPasswordReset.Query.insert(
            newPasswordReset,
            on: db
        )
        
        let input = User.Password.Set(password: "password")
        do {
            _ = try await module.password.set(token: token, input)
            XCTFail("Validation test should fail with password validation.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
            let keys = error.failures.map(\.key).sorted()
            XCTAssertEqual(keys, ["password"])
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetPassword_AccountInvalid() async throws {
        let token: String = .generateToken()
        let db = try await components.database().connection()
        let newPasswordReset = User.AccountPasswordReset.Model(
            accountId: .init(rawValue: "accountId"),
            token: token,
            expiration: Date().addingTimeInterval(86_400)
        )
        try await User.AccountPasswordReset.Query.insert(
            newPasswordReset,
            on: db
        )
        
        let input = User.Password.Set(password: "Password1")
        do {
            _ = try await module.password.set(token: token, input)
            XCTFail("Validation test should fail with User.Error.")
        }
        catch let error as User.Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 5"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetPassword_PasswordChanged() async throws {
        let token: String = .generateToken()
        let db = try await components.database().connection()
        
        let account = User.Account.Model(
            id: .init(rawValue: "accountId"),
            email: "test@test.com",
            password: "Password1")
        try await User.Account.Query.insert(
            account,
            on: db
        )

        let newPasswordReset = User.AccountPasswordReset.Model(
            accountId: .init(rawValue: "accountId"),
            token: token,
            expiration: Date().addingTimeInterval(86_400)
        )
        try await User.AccountPasswordReset.Query.insert(
            newPasswordReset,
            on: db
        )
        
        let newPassword = "Password2"
        let input = User.Password.Set(password: newPassword)
        _ = try await module.password.set(token: token, input)
        
        let updatedAccount = try await User.Account.Query.getFirst(
            filter: .init(
                column: .id,
                operator: .equal,
                value: [newPasswordReset.accountId])
            ,
            on: db)
        
        if let updatedPassword = updatedAccount?.password {
            let isValid = try Bcrypt.verify(
                newPassword,
                created: updatedPassword
            )
            XCTAssertEqual(isValid, true)
        }
    }
    
    func testPasswordReset() async throws {
        let db = try await components.database().connection()
        
        let account = User.Account.Model(
            id: .init(rawValue: "accountId"),
            email: "test@test.com",
            password: "Password1")
        try await User.Account.Query.insert(
            account,
            on: db
        )

        let input = User.Password.Reset(email: "test@test.com")
        _ = try await module.password.reset(input)
        
        let existingAccountPasswordReset = try await User.AccountPasswordReset.Query.getFirst(
            filter: .init(
                column: .accountId,
                operator: .equal,
                value: [account.id]
            ),
            on: db
        )
        XCTAssertEqual(existingAccountPasswordReset != nil, true)
    }
    
}
