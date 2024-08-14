import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import Logging
import SQLKit
import SystemModuleKit
import UserModuleKit
import NanoID

struct Oauth2Controller: UserOauth2Interface {
    
    let components: ComponentRegistry
    let user: UserModuleInterface
    
    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }
    
    func oauth2(_ request: User.Oauth2.AuthorizationGetRequest) async throws {
        try await firstChecks(
            request.clientId,
            request.redirectUri,
            request.scope,
            request.responseType
        )
    }
    
    func oauth2(_ request: User.Oauth2.AuthorizationPostRequest) async throws {
        try await firstChecks(
            request.clientId,
            request.redirectUri,
            request.scope,
            request.responseType
        )
        
        // check account
        let db = try await components.database().connection()
        guard (try await User.Account.Query.get(request.accountId.toKey(), on: db)) != nil else {
            throw User.Oauth2Error.unauthorizedClient
        }
        let model = User.AuthorizationCode.Model(
            id: NanoID.generateKey(),
            expiration: Date().addingTimeInterval(60),
            value: String.generateToken(),
            accountId: request.accountId.toKey(),
            clientId: request.clientId,
            redirectUri: request.redirectUri,
            scope: request.scope,
            state: request.state,
            codeChallenge: request.codeChallenge,
            codeChallengeMethod: request.codeChallengeMethod
        )
        try await User.AuthorizationCode.Query.insert(model, on: db)
    }
    
    func exchange(_ request: User.Oauth2.ExchangeRequest) async throws -> User.Oauth2.ExchangeResponse {
        try await firstChecks(
            request.clientId,
            request.redirectUri
        )
        if request.grantType != "authorization_code" {
            throw User.Oauth2Error.unsupportedGrant
        }
        
        let db = try await components.database().connection()
        
        guard let code = try await User.AuthorizationCode.Query.getFirst(
            filter: .init(
                column: .value,
                operator: .equal,
                value: request.code
            ),
            on: db
        ) else {
            throw User.Oauth2Error.invalidGrant
        }
        if validateCode(code, request.clientId, request.redirectUri) {
            throw User.Oauth2Error.invalidGrant
        }
        
        /*
            TODO: delete code?
        */
        
        
        return .init(jwt: "jwt")
    }
    
    
    private func firstChecks(
        _ clientId: String,
        _ redirectUri: String,
        _ scope: String? = nil,
        _ responseType: String? = nil
    ) async throws {
        let clients = try await user.system.variable.require(.init(rawValue: "clients"))
        if(!clients.value.components(separatedBy: ", ").contains(clientId)) {
            throw User.Oauth2Error.invalidClient
        }
        let redirects = try await user.system.variable.require(.init(rawValue: "redirects"))
        if(!redirects.value.components(separatedBy: ", ").contains(redirectUri)) {
            throw User.Oauth2Error.invalidRedirectURI
        }
        
        // TODO: what to do with scopes?
        
        if responseType != nil && responseType != "code" {
            throw User.Oauth2Error.invalidRequest
        }
    }
    
    private func validateCode(
        _ code: User.AuthorizationCode.Model,
        _ clientId: String,
        _ redirectUri: String
    ) -> Bool {
        guard code.clientId == clientId else {
            return true
        }
        guard code.expiration >= Date() else {
            return true
        }
        guard code.redirectUri == redirectUri else {
            return true
        }
        return false
    }
    
}
