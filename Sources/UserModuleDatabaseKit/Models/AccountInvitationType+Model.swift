import FeatherDatabase
import UserModuleKit

extension User.AccountInvitationType {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.AccountInvitationType>

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case title
        }

        public static let tableName = "user_account_invitation_type"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: KeyType
        public let title: String

        public init(
            id: KeyType,
            title: String
        ) {
            self.id = id
            self.title = title
        }
    }
}
