import DatabaseQueryKit
import UserModuleKit

extension User.AccountRole {

    public struct Model: QueryModel {

        public enum CodingKeys: String, QueryFieldKey {
            case accountId = "account_id"
            case roleKey = "role_key"
        }
        public static let fieldKeys = CodingKeys.self

        public let accountId: Key<User.Account>
        public let roleKey: Key<User.Role>

        public init(accountId: Key<User.Account>, roleKey: Key<User.Role>) {
            self.accountId = accountId
            self.roleKey = roleKey
        }
    }
}
