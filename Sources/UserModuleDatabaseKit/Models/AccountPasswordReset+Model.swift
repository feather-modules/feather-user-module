import FeatherDatabase
import Foundation
import UserModuleKit

extension User.AccountPasswordReset {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            // user_account
            case accountId = "account_id"
            case token
            case expiration
        }
        public static let tableName = "user_account_password_reset"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.accountId

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
