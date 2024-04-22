import FeatherDatabase
import UserModuleKit

extension User.PushToken {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            // user_account
            case accountId = "account_id"
            case platform
            case token
        }
        public static let tableName = "user_push_token"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.accountId

        public let accountId: Key<User.Account>
        public let platform: String
        public let token: String

        public init(
            accountId: Key<User.Account>,
            platform: String,
            token: String
        ) {
            self.accountId = accountId
            self.platform = platform
            self.token = token
        }
    }
}
