import FeatherModuleKit

public protocol UserOauth2Interface: Sendable {

    func oauth2(_ request: User.Oauth2.AuthorizationGetRequest) async throws
    
    func oauth2(_ request: User.Oauth2.AuthorizationPostRequest) async throws

    func exchange(_ request: User.Oauth2.ExchangeRequest) async throws -> User.Oauth2.ExchangeResponse
    
}
