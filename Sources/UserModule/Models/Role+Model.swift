import DatabaseQueryKit
import UserModuleInterface

extension User.Role {

    struct Model: QueryModel {

        enum CodingKeys: String, QueryFieldKey {
            case key
            case name
            case notes
        }
        static let fieldKeys = CodingKeys.self

        let key: Key<User.Role>
        let name: String
        let notes: String?

        init(
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
