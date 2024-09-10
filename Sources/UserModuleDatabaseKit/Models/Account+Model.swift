import FeatherDatabase
import Foundation
import UserModuleKit

extension User.Account {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.Account>

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case email
            case password
            case firstName = "first_name"
            case lastName = "last_name"
            case imageKey = "image_key"
        }

        public static let tableName = "user_account"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: KeyType
        public let email: String
        public let password: String
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?

        public init(
            id: KeyType,
            email: String,
            password: String,
            firstName: String?,
            lastName: String?,
            imageKey: String?
        ) {
            self.id = id
            self.email = email
            self.password = password
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
        }
    }
}
