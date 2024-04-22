import FeatherDatabase
import Foundation
import UserModuleKit

extension User.AccountInvitation {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case email
            case token
            case expiration
        }
        
        public static let tableName = "user_account_invitation"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: Key<User.Account.Model>
        public let email: String
        public let token: String
        public let expiration: Date

        public init(
            id: Key<User.Account.Model>,
            email: String,
            token: String,
            expiration: Date
        ) {
            self.id = id
            self.email = email
            self.token = token
            self.expiration = expiration
        }
    }
}
