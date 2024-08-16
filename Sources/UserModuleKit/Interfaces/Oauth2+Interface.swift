import FeatherModuleKit

public protocol UserOauth2Interface: Sendable {

    func check(_ clientId: String, _ redirectUrl: String, _ scope: String?) async throws
    
    func getCode(_ request: User.Oauth2.AuthorizationPostRequest) async throws -> String

    func exchange(_ request: User.Oauth2.ExchangeRequest) async throws -> User.Oauth2.ExchangeResponse
    
}
