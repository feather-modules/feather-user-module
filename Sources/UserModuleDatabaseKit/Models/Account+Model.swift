import DatabaseQueryKit
import Foundation
import UserModuleKit

extension User.Account {

    public struct Model: QueryModel {

        public enum CodingKeys: String, QueryFieldKey {
            case id
            case email
            case password
        }
        public static let fieldKeys = CodingKeys.self

        public let id: Key<User.Account>
        public let email: String
        public let password: String

        public init(id: Key<User.Account>, email: String, password: String) {
            self.id = id
            self.email = email
            self.password = password
        }
    }
}
