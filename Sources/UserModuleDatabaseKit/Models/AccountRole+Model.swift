import FeatherDatabase
import UserModuleKit

extension User.AccountRole {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case accountId = "account_id"
            case roleKey = "role_key"
        }
        public static let tableName = "user_account_role"
        public static let columnNames = CodingKeys.self

        public let accountId: Key<User.Account>
        public let roleKey: Key<User.Role>

        public init(accountId: Key<User.Account>, roleKey: Key<User.Role>) {
            self.accountId = accountId
            self.roleKey = roleKey
        }
    }
}
