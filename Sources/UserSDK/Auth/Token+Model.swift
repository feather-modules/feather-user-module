import DatabaseQueryKit
import Foundation
import UserSDKInterface

extension User.Token {

    struct Model: Codable {

        enum CodingKeys: String, DatabaseQueryCodingKey {
            case value
            // user_account
            case accountId = "account_id"
            case expiration
            case lastAccess = "last_access"
        }

        let value: String
        let accountId: Key<User.Account.Model>
        let expiration: Date
        let lastAccess: Date?
    }
}
