import FeatherDatabase
import UserModuleKit

extension User.Account {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.Account>

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case email
            case password
        }

        public static let tableName = "user_account"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: KeyType
        public let email: String
        public let password: String

        public init(id: KeyType, email: String, password: String) {
            self.id = id
            self.email = email
            self.password = password
        }
    }
}
