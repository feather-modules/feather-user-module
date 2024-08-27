import FeatherModuleKit

public protocol UserOauthInterface: Sendable {

    func check(
        _ clientId: String,
        _ clientSecret: String?,
        _ redirectUri: String?,
        _ scope: String?
    ) async throws

    func getCode(_ request: User.Oauth.AuthorizationPostRequest) async throws
        -> String

    func getJWT(_ request: User.Oauth.JwtRequest) async throws
        -> User.Oauth.JwtResponse

}
