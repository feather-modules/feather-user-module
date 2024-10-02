import FeatherDatabase
import UserModuleKit

extension User.AccountGroup {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.Account>

        public enum CodingKeys: String, DatabaseColumnName {
            case accountId = "account_id"
            case groupId = "group_id"
        }
        public static let tableName = "user_account_group"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.accountId

        public let accountId: KeyType
        public let groupId: Key<User.Group>

        public init(accountId: KeyType, groupId: Key<User.Group>) {
            self.accountId = accountId
            self.groupId = groupId
        }
    }
}
