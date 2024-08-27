import FeatherModuleKit
import Foundation
import JWTKit

extension User.Oauth {

    public struct Payload: JWTPayload, Equatable {
        public var iss: IssuerClaim
        public var sub: SubjectClaim
        public var aud: AudienceClaim
        public var exp: ExpirationClaim
        public var accountId: ID<User.Account>?
        public var roles: [String]?
        public var permissions: [String]?

        public init(
            iss: IssuerClaim,
            sub: SubjectClaim,
            aud: AudienceClaim,
            exp: ExpirationClaim,
            accountId: ID<User.Account>? = nil,
            roles: [String]? = nil,
            permissions: [String]? = nil
        ) {
            self.iss = iss
            self.sub = sub
            self.aud = aud
            self.exp = exp
            self.accountId = accountId
            self.roles = roles
            self.permissions = permissions
        }

        public func verify(using algorithm: some JWTKit.JWTAlgorithm)
            async throws
        {
            try self.exp.verifyNotExpired()
        }
    }

    public struct AuthorizationGetRequest: Object {
        public let clientId: String
        public let redirectUri: String
        public let scope: String?

        public init(
            clientId: String,
            redirectUri: String,
            scope: String?
        ) {
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
        }

    }

    public struct AuthorizationPostRequest: Object {
        public let clientId: String
        public let redirectUri: String
        public let scope: String?
        public let state: String?
        public let accountId: ID<User.Account>

        public init(
            clientId: String,
            redirectUri: String,
            scope: String?,
            state: String?,
            accountId: ID<User.Account>
        ) {
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
            self.state = state
            self.accountId = accountId
        }
    }

    public struct JwtRequest: Object {
        public let grantType: String
        public let clientId: String
        public let clientSecret: String?
        public let code: String?
        public let redirectUri: String?

        public init(
            grantType: String,
            clientId: String,
            clientSecret: String?,
            code: String?,
            redirectUri: String?
        ) {
            self.grantType = grantType
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.code = code
            self.redirectUri = redirectUri
        }
    }

    public struct JwtResponse: Object {
        public let jwt: String

        public init(jwt: String) {
            self.jwt = jwt
        }
    }

}
