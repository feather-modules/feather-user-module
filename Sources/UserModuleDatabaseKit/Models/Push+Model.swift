import FeatherDatabase
import Foundation
import UserModuleKit

extension User.Push {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case title
            case message
            case topic
            case date
        }
        public static let tableName = "user_push_message"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: Key<User.Push>
        public let title: String
        public let message: String
        public let topic: String
        public let date: Date

        public init(
            id: Key<User.Push>,
            title: String,
            message: String,
            topic: String,
            date: Date
        ) {
            self.id = id
            self.title = title
            self.message = message
            self.topic = topic
            self.date = date
        }
    }

}
