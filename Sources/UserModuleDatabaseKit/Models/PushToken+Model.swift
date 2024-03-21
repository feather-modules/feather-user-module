import DatabaseQueryKit
import Foundation
import UserModuleKit

extension User.PushToken {

    public struct Model: QueryModel {

        public enum CodingKeys: String, QueryFieldKey {
            // user_account
            case accountId = "account_id"
            case platform
            case token
        }
        public static let fieldKeys = CodingKeys.self

        public let accountId: UUID
        public let platform: String
        public let token: String

        public init(accountId: UUID, platform: String, token: String) {
            self.accountId = accountId
            self.platform = platform
            self.token = token
        }
    }
}
