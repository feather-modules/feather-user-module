import FeatherModuleKit
import Foundation

extension User.Token {

    public struct Detail: Object {
        public let value: ID<User.Token>
        public let expiration: Date

        public init(value: ID<User.Token>, expiration: Date) {
            self.value = value
            self.expiration = expiration
        }
    }
}
