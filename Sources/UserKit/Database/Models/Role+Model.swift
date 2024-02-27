import DatabaseQueryKit
import UserInterfaceKit

extension User.Role {

    struct Model: Codable {

        enum CodingKeys: String, DatabaseQueryCodingKey {
            case key
            case name
            case notes
        }

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
