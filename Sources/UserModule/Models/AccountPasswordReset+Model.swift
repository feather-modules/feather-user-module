import DatabaseQueryKit
import Foundation
import UserModuleInterface

extension User {
    enum AccountPasswordReset {}
}

extension User.AccountPasswordReset {

    struct Model: QueryModel {

        enum CodingKeys: String, QueryFieldKey {
            // user_account
            case accountId = "account_id"
            case token
            case expiration
        }
        static let fieldKeys = CodingKeys.self

        let accountId: Key<User.Account>
        let token: String
        let expiration: Date
    }
}
