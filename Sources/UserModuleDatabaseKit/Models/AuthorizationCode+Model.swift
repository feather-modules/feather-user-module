import FeatherDatabase
import UserModuleKit
import Foundation

extension User.AuthorizationCode {

    public struct Model: DatabaseModel {
        
        public typealias KeyType = Key<User.AuthorizationCode>

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case expiration
            case value
            case accountId = "account_id"
            case clientId = "client_id"
            case redirectUrl = "redirect_url"
            case scope
            case state
            case codeChallenge = "code_challenge"
            case codeChallengeMethod = "code_challenge_method"
        }
        
        public static let tableName = "user_authorization_code"
        public static let columnNames = CodingKeys.self
        
        public let id: KeyType
        public let expiration: Date
        public let value: String
        public let accountId: Key<User.Account>
        public let clientId: String
        public let redirectUrl: String
        public let scope: String?
        public let state: String?
        public let codeChallenge: String?
        public let codeChallengeMethod: String?
        
        public init(
            id: KeyType,
            expiration: Date,
            value: String,
            accountId: Key<User.Account>,
            clientId: String,
            redirectUrl: String,
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
            self.redirectUrl = redirectUrl
            self.scope = scope
            self.state = state
            self.codeChallenge = codeChallenge
            self.codeChallengeMethod = codeChallengeMethod
        }
    }

    
}
