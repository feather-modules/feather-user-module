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
    
    func check(_ request: User.Oauth2.AuthorizationGetRequest) async throws {
        try await checkBasic(
            request.clientId,
            request.redirectUrl,
            request.scope
        )
    }
    
    func getCode(_ request: User.Oauth2.AuthorizationPostRequest) async throws -> String {
        try await checkBasic(
            request.clientId,
            request.redirectUrl,
            request.scope
        )
        
        // check account
        let db = try await components.database().connection()
        guard (try await User.Account.Query.get(request.accountId.toKey(), on: db)) != nil else {
            throw User.Oauth2Error.unauthorizedClient
        }
        
        // generate code
        let newCode = String.generateToken()
        let model = User.AuthorizationCode.Model(
            id: NanoID.generateKey(),
            expiration: Date().addingTimeInterval(60),
            value: newCode,
            accountId: request.accountId.toKey(),
            clientId: request.clientId,
            redirectUrl: request.redirectUrl,
            scope: request.scope,
            state: request.state,
            codeChallenge: request.codeChallenge,
            codeChallengeMethod: request.codeChallengeMethod
        )
        // save to db
        try await User.AuthorizationCode.Query.insert(model, on: db)
        
        return newCode
    }
    
    func exchange(_ request: User.Oauth2.ExchangeRequest) async throws -> User.Oauth2.ExchangeResponse {
        try await checkBasic(
            request.clientId,
            request.redirectUrl
        )
        let db = try await components.database().connection()
        
        // check if code exist in db
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
        
        // validate code, delete it if error
        if !validateCode(code, request.clientId, request.redirectUrl) {
            try await deleteCode(request.code, db)
            throw User.Oauth2Error.invalidGrant
        }
        
        // delete code so it can not be used again
        try await deleteCode(request.code, db)
        
        return .init(jwt: "jwt")
    }
    
    private func deleteCode(_ code: String, _ db: Database) async throws {
        try await User.AuthorizationCode.Query.delete(
            filter: .init(
                column: .value,
                operator: .equal,
                value: code
            ),
            on: db
        )
    }
    
    // load client ids, redirect urls and scopes from system db and check
    private func checkBasic(
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
        
        // TODO: what to do with scopes? what scopes to check?
    }
    
    // valides a code before exchange
    private func validateCode(
        _ code: User.AuthorizationCode.Model,
        _ clientId: String,
        _ redirectUrl: String
    ) -> Bool {
        guard code.clientId == clientId else {
            return true
        }
        guard code.redirectUrl == redirectUrl else {
            return true
        }
        if code.expiration > Date() {
            return true
        }
        return false
    }
    
}
