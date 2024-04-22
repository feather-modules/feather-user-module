import FeatherDatabase
import UserModuleKit

extension User.Account {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case email
            case password
        }
        
        public static let tableName = "user_account"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: Key<User.Account>
        public let email: String
        public let password: String

        public init(id: Key<User.Account>, email: String, password: String) {
            self.id = id
            self.email = email
            self.password = password
        }
    }
}
