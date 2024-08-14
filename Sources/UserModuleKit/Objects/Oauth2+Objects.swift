import FeatherModuleKit
import Foundation

extension User.Oauth2{
    
    public struct AuthorizationGetRequest: Object {
        public let clientId: String
        public let redirectUrl: String
        public let scope: String?
        
        public init(
            clientId: String,
            redirectUrl: String,
            scope: String?
        ) {
            self.clientId = clientId
            self.redirectUrl = redirectUrl
            self.scope = scope
        }
        
    }
    
    public struct AuthorizationPostRequest: Object {
        public let clientId: String
        public let redirectUrl: String
        public let scope: String
        public let state: String?
        public let accountId: ID<User.Account>
        public let codeChallenge: String?
        public let codeChallengeMethod: String?
        
        public init(
            clientId: String,
            redirectUrl: String,
            scope: String,
            state: String?,
            accountId: ID<User.Account>,
            codeChallenge: String,
            codeChallengeMethod: String
        ) {
            self.clientId = clientId
            self.redirectUrl = redirectUrl
            self.scope = scope
            self.state = state
            self.accountId = accountId
            self.codeChallenge = codeChallenge
            self.codeChallengeMethod = codeChallengeMethod
        }
    }
    
    public struct ExchangeRequest: Object {
        public let grantType: String
        public let code: String
        public let clientId: String
        public let redirectUrl: String
        public let codeVerifier: String?
        
        public init(
            grantType: String,
            code: String,
            clientId: String,
            redirectUrl: String,
            codeVerifier: String?
        ) {
            self.grantType = grantType
            self.code = code
            self.clientId = clientId
            self.redirectUrl = redirectUrl
            self.codeVerifier = codeVerifier
        }
    }
    
    public struct ExchangeResponse: Object {
        public let jwt: String
        
        public init(jwt: String) {
            self.jwt = jwt
        }
    }
    
}
