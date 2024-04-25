import FeatherDatabase
import Foundation
import UserModuleKit

extension User.Token {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case value
            // user_account
            case accountId = "account_id"
            case expiration
            case lastAccess = "last_access"
        }
        public static let tableName = "user_token"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.accountId

        public let value: String
        public let accountId: Key<User.Account>
        public let expiration: Date
        public let lastAccess: Date?

        public init(
            value: String,
            accountId: Key<User.Account>,
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
