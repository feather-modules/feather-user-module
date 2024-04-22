import FeatherDatabase
import UserModuleKit

extension User.Role {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case key
            case name
            case notes
        }
        public static let tableName = "user_role"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.key

        public let key: Key<User.Role>
        public let name: String
        public let notes: String?

        public init(
            key: Key<User.Role>,
            name: String,
            notes: String? = nil
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
