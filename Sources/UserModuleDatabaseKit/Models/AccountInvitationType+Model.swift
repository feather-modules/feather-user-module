import FeatherDatabase
import UserModuleKit

extension User.AccountInvitationType {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.AccountInvitationType>

        public enum CodingKeys: String, DatabaseColumnName {
            case key
            case title
        }

        public static let tableName = "user_account_invitation_type"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.key

        public let key: KeyType
        public let title: String

        public init(
            key: KeyType,
            title: String
        ) {
            self.key = key
            self.title = title
        }
    }
}
