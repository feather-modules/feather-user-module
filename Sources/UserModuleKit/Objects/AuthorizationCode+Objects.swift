import FeatherModuleKit
import Foundation

extension User.AuthorizationCode {

    public struct Detail: Object {
        public let id: ID<User.AuthorizationCode>
        public let expiration: Date
        public let value: String
        public let accountId: ID<User.Account>
        public let clientId: String
        public let redirectUri: String
        public let scope: String?
        public let state: String?
        public let codeChallenge: String?
        public let codeChallengeMethod: String?

        public init(
            id: ID<User.AuthorizationCode>,
            expiration: Date,
            value: String,
            accountId: ID<User.Account>,
            clientId: String,
            redirectUri: String,
            scope: String?,
            state: String?,
            codeChallenge: String? = nil,
            codeChallengeMethod: String? = nil
        ) {
            self.id = id
            self.expiration = expiration
            self.value = value
            self.accountId = accountId
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
            self.state = state
            self.codeChallenge = codeChallenge
            self.codeChallengeMethod = codeChallengeMethod
        }
    }

    public struct Create: Object {
        public let accountId: ID<User.Account>
        public let clientId: String
        public let redirectUri: String
        public let scope: String?
        public let state: String?
        public let codeChallenge: String?
        public let codeChallengeMethod: String?

        public init(
            accountId: ID<User.Account>,
            clientId: String,
            redirectUri: String,
            scope: String?,
            state: String?,
            codeChallenge: String? = nil,
            codeChallengeMethod: String? = nil
        ) {
            self.accountId = accountId
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
            self.state = state
            self.codeChallenge = codeChallenge
            self.codeChallengeMethod = codeChallengeMethod
        }

    }

}
