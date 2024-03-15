import DatabaseQueryKit
import Foundation
import UserModuleInterface

extension User.Token {

    struct Model: QueryModel {

        enum CodingKeys: String, QueryFieldKey {
            case value
            // user_account
            case accountId = "account_id"
            case expiration
            case lastAccess = "last_access"
        }
        static let fieldKeys = CodingKeys.self

        let value: String
        let accountId: Key<User.Account.Model>
        let expiration: Date
        let lastAccess: Date?
    }
}
