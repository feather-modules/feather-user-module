import FeatherModuleKit

public protocol UserOauthInterface: Sendable {
    
    func check(_ clientId: String, _ redirectUrl: String, _ scope: String?) async throws
    
    func getCode(_ request: User.Oauth.AuthorizationPostRequest) async throws -> String

    func exchange(_ request: User.Oauth.ExchangeRequest) async throws -> User.Oauth.ExchangeResponse
    
}
