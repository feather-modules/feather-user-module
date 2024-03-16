import DatabaseQueryKit
import Foundation
import UserModuleKit

extension User.PushToken {

    struct Model: QueryModel {

        enum CodingKeys: String, QueryFieldKey {
            // user_account
            case accountId = "account_id"
            case platform
            case token
        }
        static let fieldKeys = CodingKeys.self

        let accountId: UUID
        let platform: String
        let token: String
    }
}
