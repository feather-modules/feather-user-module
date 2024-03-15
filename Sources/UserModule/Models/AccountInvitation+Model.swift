import DatabaseQueryKit
import Foundation
import UserModuleInterface

extension User {
    enum AccountInvitation {}
}

extension User.AccountInvitation {

    struct Model: QueryModel {

        enum CodingKeys: String, QueryFieldKey {
            case id
            case email
            case token
            case expiration
        }
        static let fieldKeys = CodingKeys.self

        let id: Key<User.Account.Model>
        let email: String
        let token: String
        let expiration: Date
    }
}
