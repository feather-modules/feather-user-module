import CoreSDKInterface
import Foundation

extension User.Token: Identifiable {}

public protocol UserTokenDetail {
    var value: ID<User.Token> { get }
    var expiration: Date { get }
}
