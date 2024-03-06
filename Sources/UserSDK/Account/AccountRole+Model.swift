import DatabaseQueryKit
import UserSDKInterface

extension User {
    enum AccountRole {}
}

extension User.AccountRole {

    struct Model: Codable {

        enum CodingKeys: String, DatabaseQueryCodingKey {
            case accountId = "account_id"
            case roleKey = "role_key"
        }

        let accountId: Key<User.Account>
        let roleKey: Key<User.Role>
    }
}
