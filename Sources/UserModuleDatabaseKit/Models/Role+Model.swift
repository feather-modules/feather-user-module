import FeatherDatabase
import UserModuleKit

extension User.Role {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.Role>

        public enum CodingKeys: String, DatabaseColumnName {
            case key
            case name
            case notes
            case type
        }
        public static let tableName = "user_role"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.key

        public let key: KeyType
        public let name: String
        public let notes: String?
        public let type: String

        public init(
            key: KeyType,
            name: String,
            notes: String? = nil,
            type: String
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.type = type
        }
    }
}
