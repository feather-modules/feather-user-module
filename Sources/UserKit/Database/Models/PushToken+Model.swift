import DatabaseQueryKit
import Foundation
import UserInterfaceKit

extension User.PushToken {

    struct Model: Codable {

        enum CodingKeys: String, DatabaseQueryCodingKey {
            // user_account
            case accountId = "account_id"
            case platform
            case token
        }

        let accountId: UUID
        let platform: String
        let token: String
    }
}
