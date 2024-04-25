import FeatherDatabase
import Foundation
import UserModuleKit

extension User.AccountInvitation {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.Account>

        public enum CodingKeys: String, DatabaseColumnName {
            case accountId
            case email
            case token
            case expiration
        }

        public static let tableName = "user_account_invitation"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.accountId

        public let accountId: KeyType
        public let email: String
        public let token: String
        public let expiration: Date

        public init(
            accountId: KeyType,
            email: String,
            token: String,
            expiration: Date
        ) {
            self.accountId = accountId
            self.email = email
            self.token = token
            self.expiration = expiration
        }
    }
}
