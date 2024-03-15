import DatabaseQueryKit
import UserModuleInterface

extension User {
    enum AccountRole {}
}

extension User.AccountRole {

    struct Model: QueryModel {

        enum CodingKeys: String, QueryFieldKey {
            case accountId = "account_id"
            case roleKey = "role_key"
        }
        static let fieldKeys = CodingKeys.self

        let accountId: Key<User.Account>
        let roleKey: Key<User.Role>
    }
}
