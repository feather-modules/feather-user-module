import FeatherModuleKit
import SystemModule
import SystemModuleKit
import UserModule
import UserModuleKit
import XCTest

final class OauthTests: TestCase {

    func testCheckBadClient() async throws {
        let client = try await addTestClient()
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: "client",
            redirectUri: client.redirectUri,
            scope: "read+write"
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCheckBadRedirectUri() async throws {
        let client = try await addTestClient()
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: client.id.rawValue,
            redirectUri: "localhost",
            scope: "read+write"
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
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
        let client = try await addTestClient()
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: client.id.rawValue,
            redirectUri: client.redirectUri,
            scope: "read+write"
        )

        _ = try await module.oauth.check(
            request.clientId,
            nil,
            request.redirectUri,
            request.scope
        )
    }

    // MARK: test getCode

    func testGetCodeBadClient() async throws {
        let client = try await addTestClient()
        let user = try await createUser()

        let request = User.Oauth.AuthorizationPostRequest(
            clientId: "client",
            redirectUri: client.redirectUri,
            scope: "read+write",
            state: "state",
            accountId: user.id
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
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

    func testGetCodeBadRedirectUri() async throws {
        let client = try await addTestClient()
        let user = try await createUser()

        let request = User.Oauth.AuthorizationPostRequest(
            clientId: client.id.rawValue,
            redirectUri: "localhost",
            scope: "read+write",
            state: "state",
            accountId: user.id
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
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
        let client = try await addTestClient()

        let request = User.Oauth.AuthorizationPostRequest(
            clientId: client.id.rawValue,
            redirectUri: client.redirectUri,
            scope: "read+write",
            state: "state",
            accountId: .init(rawValue: "badId")
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
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
        let client = try await addTestClient()
        let user = try await createUser()

        let request = User.Oauth.AuthorizationPostRequest(
            clientId: client.id.rawValue,
            redirectUri: client.redirectUri,
            scope: "read+write",
            state: "state",
            accountId: user.id
        )

        _ = try await module.oauth.check(
            request.clientId,
            nil,
            request.redirectUri,
            request.scope
        )
        let newCode = try await module.oauth.getCode(request)
        XCTAssertEqual(true, newCode.count > 0)
    }

    // MARK: test exchange

    func testExchangeBadClient() async throws {
        let client = try await addTestClient()
        let testData = try await createAuthorizationCode(
            client.id.rawValue,
            client.redirectUri
        )

        let request = User.Oauth.JwtRequest(
            grantType: "authorization_code",
            clientId: "client",
            clientSecret: nil,
            code: testData,
            redirectUri: client.redirectUri
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                nil,
                request.redirectUri,
                nil
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testExchangeBadRedirectUri() async throws {
        let client = try await addTestClient()
        let testData = try await createAuthorizationCode(
            client.id.rawValue,
            client.redirectUri
        )

        let request = User.Oauth.JwtRequest(
            grantType: "authorization_code",
            clientId: client.id.rawValue,
            clientSecret: nil,
            code: testData,
            redirectUri: "badRedirectUri"
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                nil,
                request.redirectUri,
                nil
            )
            _ = try await module.oauth.getJWT(request)
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
        let client = try await addTestClient()
        _ = try await createAuthorizationCode(
            client.id.rawValue,
            client.redirectUri
        )

        let request = User.Oauth.JwtRequest(
            grantType: "authorization_code",
            clientId: client.id.rawValue,
            clientSecret: nil,
            code: "badCode",
            redirectUri: client.redirectUri
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                nil,
                request.redirectUri,
                nil
            )
            _ = try await module.oauth.getJWT(request)
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
        let client = try await addTestClient()
        let testCode = try await createAuthorizationCode(
            client.id.rawValue,
            client.redirectUri
        )

        let request = User.Oauth.JwtRequest(
            grantType: "authorization_code",
            clientId: client.id.rawValue,
            clientSecret: nil,
            code: testCode,
            redirectUri: client.redirectUri
        )
        _ = try await module.oauth.check(
            request.clientId,
            nil,
            request.redirectUri,
            nil
        )
        _ = try await module.oauth.getJWT(request)
    }

    // MARK: test server credentials

    func testServerCredentialsBadClient() async throws {
        let client = try await addTestClient()

        let request = User.Oauth.JwtRequest(
            grantType: "client_credentials",
            clientId: "badClient",
            clientSecret: client.clientSecret,
            code: nil,
            redirectUri: nil
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                request.clientSecret,
                request.redirectUri,
                nil
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testServerCredentialsBadSecret() async throws {
        let client = try await addTestClient()

        let request = User.Oauth.JwtRequest(
            grantType: "client_credentials",
            clientId: client.id.rawValue,
            clientSecret: "badSecret",
            code: nil,
            redirectUri: nil
        )

        do {
            _ = try await module.oauth.check(
                request.clientId,
                request.clientSecret,
                request.redirectUri,
                nil
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testServerCredentials() async throws {
        let client = try await addTestClient()

        let request = User.Oauth.JwtRequest(
            grantType: "client_credentials",
            clientId: client.id.rawValue,
            clientSecret: client.clientSecret,
            code: nil,
            redirectUri: nil
        )

        _ = try await module.oauth.check(
            request.clientId,
            request.clientSecret,
            request.redirectUri,
            nil
        )
        _ = try await module.oauth.getJWT(request)
    }

    // MARK: private

    private func createAuthorizationCode(
        _ clientId: String,
        _ redirectUri: String
    ) async throws -> String {
        let user = try await createUser()
        let request = User.Oauth.AuthorizationPostRequest(
            clientId: clientId,
            redirectUri: redirectUri,
            scope: "read+write",
            state: "state",
            accountId: user.id
        )
        return try await module.oauth.getCode(request)
    }

    private func createUser() async throws -> User.Account.Detail {
        let email = "test@user.com"
        let password = "ChangeMe1"

        return try await module.account.create(
            User.Account.Create(
                email: email,
                password: password
            )
        )
    }

    private func addTestClient() async throws -> User.OauthClient.Detail {
        try await module.oauthClient.create(
            .init(
                name: "client1",
                type: User.OauthClient.ClientType.app,
                redirectUri: "localhost1",
                loginRedirectUri: "loginRedirectUri1",
                issuer: "issuer",
                subject: "subject",
                audience: "audience"
            )
        )
    }

}
