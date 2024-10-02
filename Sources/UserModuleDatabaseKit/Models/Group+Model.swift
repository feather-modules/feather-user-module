import FeatherDatabase
import Foundation
import UserModuleKit

extension User.Group {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.Group>

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case name
        }

        public static let tableName = "user_group"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: KeyType
        public let name: String

        public init(
            id: KeyType,
            name: String
        ) {
            self.id = id
            self.name = name
        }
    }
}
