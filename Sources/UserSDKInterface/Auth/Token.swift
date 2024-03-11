import CoreSDKInterface
import Foundation

extension User.Token: Identifiable {}

public protocol UserTokenDetail {
    var value: ID<User.Token> { get }
    var expiration: Date { get }
}

extension User.Token {

    public struct Detail: UserTokenDetail {
        public let value: ID<User.Token>
        public let expiration: Date

        public init(value: ID<User.Token>, expiration: Date) {
            self.value = value
            self.expiration = expiration
        }
    }
}
