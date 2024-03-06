import DatabaseQueryKit
import Foundation
import UserSDKInterface

extension User {
    enum AccountInvitation {}
}

extension User.AccountInvitation {

    struct Model: Codable {

        enum CodingKeys: String, DatabaseQueryCodingKey {
            case id
            case email
            case token
            case expiration
        }

        let id: Key<User.Account.Model>
        let email: String
        let token: String
        let expiration: Date
    }
}
