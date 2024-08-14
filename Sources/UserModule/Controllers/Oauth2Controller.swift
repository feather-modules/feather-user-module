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
            request.redirectUrl,
            request.scope
        )
    }
    
    func oauth2(_ request: User.Oauth2.AuthorizationPostRequest) async throws {
        try await firstChecks(
            request.clientId,
            request.redirectUrl,
            request.scope
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
            redirectUrl: request.redirectUrl,
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
            request.redirectUrl
        )
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
        if validateCode(code, request.clientId, request.redirectUrl) {
            throw User.Oauth2Error.invalidGrant
        }
        
        /*
            TODO: delete code?
        */
        
        
        return .init(jwt: "jwt")
    }
    
    
    private func firstChecks(
        _ clientId: String,
        _ redirectUrl: String,
        _ scope: String? = nil
    ) async throws {
        let clients = try await user.system.variable.require(.init(rawValue: "clients"))
        if(!clients.value.components(separatedBy: ", ").contains(clientId)) {
            throw User.Oauth2Error.invalidClient
        }
        let redirects = try await user.system.variable.require(.init(rawValue: "redirects"))
        if(!redirects.value.components(separatedBy: ", ").contains(redirectUrl)) {
            throw User.Oauth2Error.invalidRedirectURI
        }
        
        // TODO: what to do with scopes?
    }
    
    private func validateCode(
        _ code: User.AuthorizationCode.Model,
        _ clientId: String,
        _ redirectUrl: String
    ) -> Bool {
        guard code.clientId == clientId else {
            return true
        }
        guard code.expiration >= Date() else {
            return true
        }
        guard code.redirectUrl == redirectUrl else {
            return true
        }
        return false
    }
    
}
