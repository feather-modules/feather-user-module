import FeatherModuleKit
import Foundation

extension User.Oauth2{
    
    public struct AuthorizationGetRequest: Object {
        public let clientId: String
        public let redirectUri: String
        public let scope: String
        public let state: String?
        public let responseType: String
        
        public init(
            clientId: String,
            redirectUri: String,
            scope: String,
            state: String?,
            responseType: String
        ) {
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
            self.state = state
            self.responseType = responseType
        }
        
    }
    
    public struct AuthorizationPostRequest: Object {
        public let clientId: String
        public let redirectUri: String
        public let scope: String
        public let state: String?
        public let responseType: String
        public let accountId: ID<User.Account>
        public let codeChallenge: String?
        public let codeChallengeMethod: String?
        
        public init(
            clientId: String,
            redirectUri: String,
            scope: String,
            state: String?,
            responseType: String,
            accountId: ID<User.Account>,
            codeChallenge: String,
            codeChallengeMethod: String
        ) {
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
            self.state = state
            self.responseType = responseType
            self.accountId = accountId
            self.codeChallenge = codeChallenge
            self.codeChallengeMethod = codeChallengeMethod
        }
    }
    
    public struct ExchangeRequest: Object {
        public let grantType: String
        public let code: String
        public let clientId: String
        public let redirectUri: String
        public let codeVerifier: String?
        
        public init(
            grantType: String,
            code: String,
            clientId: String,
            redirectUri: String,
            codeVerifier: String?
        ) {
            self.grantType = grantType
            self.code = code
            self.clientId = clientId
            self.redirectUri = redirectUri
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
