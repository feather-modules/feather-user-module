import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import Logging
import UserModuleKit
import NanoID
import JWTKit

struct OauthController: UserOauthInterface {
   
    let components: ComponentRegistry
    let user: UserModuleInterface
    
    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }
    
    
    func check(_ clientId: String, _ redirectUrl: String, _ scope: String? = nil) async throws {
        
        let clients = try await user.system.variable.require(.init(rawValue: "clients"))
        if(!clients.value.components(separatedBy: ", ").contains(clientId)) {
            throw User.OauthError.invalidClient
        }
        let redirects = try await user.system.variable.require(.init(rawValue: "redirects"))
        if(!redirects.value.components(separatedBy: ", ").contains(redirectUrl)) {
            throw User.OauthError.invalidRedirectURI
        }
        
        // TODO: what to do with scopes? what scopes to check?
    }
    
    func getCode(_ request: User.Oauth.AuthorizationPostRequest) async throws -> String {
        
        let db = try await components.database().connection()
        
        // check account
        guard (try await User.Account.Query.get(request.accountId.toKey(), on: db)) != nil else {
            throw User.OauthError.unauthorizedClient
        }
        
        // create and save new code
        let detail = try await user.authorizationCode.create(.init(
            accountId: request.accountId,
            clientId: request.clientId,
            redirectUrl: request.redirectUrl,
            scope: request.scope,
            state: request.state,
            codeChallenge: request.codeChallenge,
            codeChallengeMethod: request.codeChallengeMethod
        ))
        
        return detail.value
    }
    
    func exchange(_ request: User.Oauth.ExchangeRequest) async throws -> User.Oauth.ExchangeResponse {
        let db = try await components.database().connection()
        
        // check if code exist in db
        guard let code = try await User.AuthorizationCode.Query.getFirst(
            filter: .init(
                column: .value,
                operator: .equal,
                value: request.code
            ),
            on: db
        ) else {
            throw User.OauthError.invalidGrant
        }
        
        // validate code, delete it if error
        if !validateCode(code, request.clientId, request.redirectUrl) {
            try await deleteCode(request.code, db)
            throw User.OauthError.invalidGrant
        }
        
        // delete code so it can not be used again
        try await deleteCode(request.code, db)
        
        // create (for testing now)
        let keys = JWTKeyCollection()
        await keys.add(hmac: "secret", digestAlgorithm: .sha512, kid: "kid")
        
        guard let account = try await User.Account.Query.get(code.accountId, on: db) else {
            throw User.OauthError.unauthorizedClient
        }
        let data = try await account.id.toID().getRolesAndPermissonsForId(user, db)
        
        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: "String"),
            sub: SubjectClaim(value: "String"),
            aud: AudienceClaim(value: ["String"]),
            exp: ExpirationClaim(value: Date().addingTimeInterval(12000000)),
            accountId: code.accountId.toID(),
            roles: data.0.map { $0.key.rawValue },
            permissions: data.1.map { $0.rawValue }
        )
        let jwt = try await keys.sign(payload, kid: "kid")
        
        
        return .init(jwt: jwt)
    }
    
    private func deleteCode(_ code: String, _ db: Database) async throws {
        try await User.AuthorizationCode.Query.delete(
            filter: .init(
                column: .value,
                operator: .equal,
                value: code
            ),
            on: db
        )
    }
    
    // valides a code before exchange
    private func validateCode(
        _ code: User.AuthorizationCode.Model,
        _ clientId: String,
        _ redirectUrl: String
    ) -> Bool {
        if code.clientId != clientId {
            return false
        }
        else if code.redirectUrl != redirectUrl {
            return false
        }
        else if code.expiration < Date() {
            return false
        }
        return true
    }
    
}
