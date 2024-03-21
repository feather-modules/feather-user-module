import DatabaseQueryKit
import Foundation
import UserModuleKit

extension User.AccountPasswordReset {

    public struct Model: QueryModel {

        public enum CodingKeys: String, QueryFieldKey {
            // user_account
            case accountId = "account_id"
            case token
            case expiration
        }
        public static let fieldKeys = CodingKeys.self

        public let accountId: Key<User.Account>
        public let token: String
        public let expiration: Date

        public init(
            accountId: Key<User.Account>,
            token: String,
            expiration: Date
        ) {
            self.accountId = accountId
            self.token = token
            self.expiration = expiration
        }

    }
}
