import FeatherModuleKit
import SystemModule
import SystemModuleKit
import UserModule
import UserModuleKit
import XCTest

final class Oauth2Tests: TestCase {
    
    func testCheckBadClient() async throws {
        try await addSystemVariables()
        let request = User.Oauth2.AuthorizationGetRequest(
            clientId: "client",
            redirectUrl: "localhost",
            scope: "read+write")
        
        do {
            _ = try await module.oauth2.check(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testCheckBadRedirectUrl() async throws {
        try await addSystemVariables()
        let request = User.Oauth2.AuthorizationGetRequest(
            clientId: "client1",
            redirectUrl: "localhost",
            scope: "read+write")
        
        do {
            _ = try await module.oauth2.check(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testCheck() async throws {
        try await addSystemVariables()
        let request = User.Oauth2.AuthorizationGetRequest(
            clientId: "client1",
            redirectUrl: "localhost1",
            scope: "read+write")
        
        _ = try await module.oauth2.check(request)
    }
    
    // MARK: test getCode
    
    func testGetCodeBadClient() async throws {
        let user = try await createUser()
        
        let request = User.Oauth2.AuthorizationPostRequest(
            clientId: "client",
            redirectUrl: "localhost1",
            scope: "read+write",
            state: "state",
            accountId: user.id,
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        
        do {
            _ = try await module.oauth2.getCode(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetCodeBadRedirectUrl() async throws {
        let user = try await createUser()
        
        let request = User.Oauth2.AuthorizationPostRequest(
            clientId: "client1",
            redirectUrl: "localhost",
            scope: "read+write",
            state: "state",
            accountId: user.id,
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        
        do {
            _ = try await module.oauth2.getCode(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetCodeBadAccount() async throws {
        try await addSystemVariables()
        
        let request = User.Oauth2.AuthorizationPostRequest(
            clientId: "client1",
            redirectUrl: "localhost1",
            scope: "read+write",
            state: "state",
            accountId: .init(rawValue: "badId"),
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        
        do {
            _ = try await module.oauth2.getCode(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 6"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetCode() async throws {
        let user = try await createUser()
        
        let request = User.Oauth2.AuthorizationPostRequest(
            clientId: "client1",
            redirectUrl: "localhost1",
            scope: "read+write",
            state: "state",
            accountId: user.id,
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        
        let newCode = try await module.oauth2.getCode(request)
        XCTAssertEqual(true, newCode.count > 0)
    }
    
    // MARK: test exchange
    
    func testExchangeBadClient() async throws {
        let testData = try await createAuthorizationCode()
        
        let request = User.Oauth2.ExchangeRequest(
            grantType: "authorization_code",
            code: testData.1,
            accountId: testData.0,
            clientId: "client",
            redirectUrl: "localhost1",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth2.exchange(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchangeBadRedirectUrl() async throws {
        let testData = try await createAuthorizationCode()
        
        let request = User.Oauth2.ExchangeRequest(
            grantType: "authorization_code",
            code: testData.1,
            accountId: testData.0,
            clientId: "client1",
            redirectUrl: "localhost",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth2.exchange(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchangeBadAccount() async throws {
        let testData = try await createAuthorizationCode()
        
        let request = User.Oauth2.ExchangeRequest(
            grantType: "authorization_code",
            code: "badCode",
            accountId: testData.0,
            clientId: "client1",
            redirectUrl: "localhost1",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth2.exchange(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 4"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchangeBadcode() async throws {
        let testData = try await createAuthorizationCode()
        
        let request = User.Oauth2.ExchangeRequest(
            grantType: "authorization_code",
            code: testData.1,
            accountId: .init(rawValue: "badId"),
            clientId: "client1",
            redirectUrl: "localhost1",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth2.exchange(request)
            XCTFail("Test should fail with User.Oauth2Error")
        }
        catch let error as User.Oauth2Error {
            XCTAssertEqual(true, error.localizedDescription.contains("error 6"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchange() async throws {
        let testData = try await createAuthorizationCode()
        
        let request = User.Oauth2.ExchangeRequest(
            grantType: "authorization_code",
            code: testData.1,
            accountId: testData.0,
            clientId: "client1",
            redirectUrl: "localhost1",
            codeVerifier: nil
        )
        _ = try await module.oauth2.exchange(request)
    }
    
    // MARK: private
    
    private func createAuthorizationCode(_ interval: TimeInterval = 60) async throws -> (ID<User.Account>, String){
        let user = try await createUser()
        let request = User.Oauth2.AuthorizationPostRequest(
            clientId: "client1",
            redirectUrl: "localhost1",
            scope: "read+write",
            state: "state",
            accountId: user.id,
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        let newCode = try await module.oauth2.getCode(request)
        return (user.id, newCode)
    }
    
    private func createUser() async throws -> User.Account.Detail{
        try await addSystemVariables()
        let email = "test@user.com"
        let password = "ChangeMe1"
        
        return try await module.account.create(
            User.Account.Create(
                email: email,
                password: password
            )
        )
    }
    
    private func addSystemVariables() async throws {
        try await addSystemVariableTestData("clients", "client1, client2")
        try await addSystemVariableTestData("redirects", "localhost1, localhost2")
    }
    
    private func addSystemVariableTestData(_ key: String, _ value: String) async throws{
        _ = try await module.system.variable.create(
            .init(
                key: .init(rawValue: key),
                value: value
            )
        )
    }
    
    
    
}
