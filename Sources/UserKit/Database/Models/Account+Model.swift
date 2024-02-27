import DatabaseQueryKit
import Foundation
import UserInterfaceKit

extension User.Account {

    struct Model: Codable {

        enum CodingKeys: String, DatabaseQueryCodingKey {
            case id
            case email
            case password
        }

        let id: Key<User.Account>
        let email: String
        let password: String
    }
}
