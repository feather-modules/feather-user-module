import FeatherModuleKit
import SystemModule
import SystemModuleKit
import UserModule
import UserModuleKit
import XCTest

final class OauthTests: TestCase {
    
    func testCheckBadClient() async throws {
        try await addSystemVariables()
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: "client",
            redirectUrl: "localhost",
            scope: "read+write")
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, request.scope)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testCheckBadRedirectUrl() async throws {
        try await addSystemVariables()
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: "client1",
            redirectUrl: "localhost",
            scope: "read+write")
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, request.scope)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testCheck() async throws {
        try await addSystemVariables()
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: "client1",
            redirectUrl: "localhost1",
            scope: "read+write")
        
        _ = try await module.oauth.check(request.clientId, request.redirectUrl, request.scope)
    }
    
    // MARK: test getCode
    
    func testGetCodeBadClient() async throws {
        let user = try await createUser()
        
        let request = User.Oauth.AuthorizationPostRequest(
            clientId: "client",
            redirectUrl: "localhost1",
            scope: "read+write",
            state: "state",
            accountId: user.id,
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, request.scope)
            _ = try await module.oauth.getCode(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetCodeBadRedirectUrl() async throws {
        let user = try await createUser()
        
        let request = User.Oauth.AuthorizationPostRequest(
            clientId: "client1",
            redirectUrl: "localhost",
            scope: "read+write",
            state: "state",
            accountId: user.id,
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, request.scope)
            _ = try await module.oauth.getCode(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetCodeBadAccount() async throws {
        try await addSystemVariables()
        
        let request = User.Oauth.AuthorizationPostRequest(
            clientId: "client1",
            redirectUrl: "localhost1",
            scope: "read+write",
            state: "state",
            accountId: .init(rawValue: "badId"),
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, request.scope)
            _ = try await module.oauth.getCode(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 6"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetCode() async throws {
        let user = try await createUser()
        
        let request = User.Oauth.AuthorizationPostRequest(
            clientId: "client1",
            redirectUrl: "localhost1",
            scope: "read+write",
            state: "state",
            accountId: user.id,
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        
        _ = try await module.oauth.check(request.clientId, request.redirectUrl, request.scope)
        let newCode = try await module.oauth.getCode(request)
        XCTAssertEqual(true, newCode.count > 0)
    }
    
    // MARK: test exchange
    
    func testExchangeBadClient() async throws {
        let testData = try await createAuthorizationCode()
        
        let request = User.Oauth.ExchangeRequest(
            grantType: "authorization_code",
            code: testData,
            clientId: "client",
            redirectUrl: "localhost1",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, nil)
            _ = try await module.oauth.exchange(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchangeBadRedirectUrl() async throws {
        let testData = try await createAuthorizationCode()
        
        let request = User.Oauth.ExchangeRequest(
            grantType: "authorization_code",
            code: testData,
            clientId: "client1",
            redirectUrl: "localhost",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, nil)
            _ = try await module.oauth.exchange(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchangeBadcode() async throws {
        _ = try await createAuthorizationCode()
        
        let request = User.Oauth.ExchangeRequest(
            grantType: "authorization_code",
            code: "badCode",
            clientId: "client1",
            redirectUrl: "localhost1",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, nil)
            _ = try await module.oauth.exchange(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 4"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchangeGoodCodeBadClient() async throws {
        let testCode = try await createAuthorizationCode()
        
        let request = User.Oauth.ExchangeRequest(
            grantType: "authorization_code",
            code: testCode,
            clientId: "client2",
            redirectUrl: "localhost1",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, nil)
            _ = try await module.oauth.exchange(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 4"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchangeGoodCodeBadRedirectUrl() async throws {
        let testCode = try await createAuthorizationCode()
        
        let request = User.Oauth.ExchangeRequest(
            grantType: "authorization_code",
            code: testCode,
            clientId: "client1",
            redirectUrl: "localhost2",
            codeVerifier: nil
        )
        
        do {
            _ = try await module.oauth.check(request.clientId, request.redirectUrl, nil)
            _ = try await module.oauth.exchange(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 4"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExchange() async throws {
        let testCode = try await createAuthorizationCode()
        
        let request = User.Oauth.ExchangeRequest(
            grantType: "authorization_code",
            code: testCode,
            clientId: "client1",
            redirectUrl: "localhost1",
            codeVerifier: nil
        )
        _ = try await module.oauth.check(request.clientId, request.redirectUrl, nil)
        let obj = try await module.oauth.exchange(request)
        
        print(obj)
    }
    
    // MARK: private
    
    private func createAuthorizationCode() async throws -> String{
        let user = try await createUser()
        let request = User.Oauth.AuthorizationPostRequest(
            clientId: "client1",
            redirectUrl: "localhost1",
            scope: "read+write",
            state: "state",
            accountId: user.id,
            codeChallenge: nil,
            codeChallengeMethod: nil
        )
        return try await module.oauth.getCode(request)
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
