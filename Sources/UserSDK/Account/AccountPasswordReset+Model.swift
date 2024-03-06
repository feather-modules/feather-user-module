import DatabaseQueryKit
import Foundation
import UserSDKInterface

extension User {
    enum AccountPasswordReset {}
}

extension User.AccountPasswordReset {

    struct Model: Codable {

        enum CodingKeys: String, DatabaseQueryCodingKey {
            // user_account
            case accountId = "account_id"
            case token
            case expiration
        }

        let accountId: Key<User.Account>
        let token: String
        let expiration: Date
    }
}
