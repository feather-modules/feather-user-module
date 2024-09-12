import FeatherDatabase
import UserModuleKit

extension User.AccountRole {

    public struct Model: KeyedDatabaseModel {
        
        public typealias KeyType = Key<User.Account>

        public enum CodingKeys: String, DatabaseColumnName {
            case accountId = "account_id"
            case roleKey = "role_key"
        }
        public static let tableName = "user_account_role"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.accountId

        public let accountId: KeyType
        public let roleKey: Key<User.Role>

        public init(accountId: KeyType, roleKey: Key<User.Role>) {
            self.accountId = accountId
            self.roleKey = roleKey
        }
    }
}
