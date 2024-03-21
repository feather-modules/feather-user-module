import DatabaseQueryKit
import Foundation
import UserModuleKit

extension User.Token {

    public struct Model: QueryModel {

        public enum CodingKeys: String, QueryFieldKey {
            case value
            // user_account
            case accountId = "account_id"
            case expiration
            case lastAccess = "last_access"
        }
        public static let fieldKeys = CodingKeys.self

        public let value: String
        public let accountId: Key<User.Account.Model>
        public let expiration: Date
        public let lastAccess: Date?

        public init(
            value: String,
            accountId: Key<User.Account.Model>,
            expiration: Date,
            lastAccess: Date? = nil
        ) {
            self.value = value
            self.accountId = accountId
            self.expiration = expiration
            self.lastAccess = lastAccess
        }
    }
}
