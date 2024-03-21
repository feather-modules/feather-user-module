import DatabaseQueryKit
import Foundation
import UserModuleKit

extension User.AccountInvitation {

    public struct Model: QueryModel {

        public enum CodingKeys: String, QueryFieldKey {
            case id
            case email
            case token
            case expiration
        }
        public static let fieldKeys = CodingKeys.self

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
