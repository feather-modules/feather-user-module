import DatabaseQueryKit
import Foundation
import UserModuleInterface

extension User.Account {

    struct Model: QueryModel {

        enum CodingKeys: String, QueryFieldKey {
            case id
            case email
            case password
        }
        static let fieldKeys = CodingKeys.self

        let id: Key<User.Account>
        let email: String
        let password: String
    }
}
