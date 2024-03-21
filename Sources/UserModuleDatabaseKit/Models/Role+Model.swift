import DatabaseQueryKit
import UserModuleKit

extension User.Role {

    public struct Model: QueryModel {

        public enum CodingKeys: String, QueryFieldKey {
            case key
            case name
            case notes
        }
        public static let fieldKeys = CodingKeys.self

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
