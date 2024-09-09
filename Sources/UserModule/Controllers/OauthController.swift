import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import JWTKit
import Logging
import NanoID
import UserModuleKit

struct OauthController: UserOauthInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    func check(
        _ grantType: User.Oauth.OauthFlowType?,
        _ clientId: String,
        _ clientSecret: String?,
        _ redirectUri: String?,
        _ scope: String? = nil
    ) async throws -> String? {
        let db = try await components.database().connection()
        guard
            let oauthClient = try await User.OauthClient.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: clientId
                ),
                on: db
            )
        else {
            throw User.OauthError.invalidClient
        }

        // TODO: bettor scope handling/check

        if grantType == .clientCredentials {
            if oauthClient.clientSecret != clientSecret {
                throw User.OauthError.invalidClient
            }
            if scope != "server" {
                throw User.OauthError.invalidScope
            }

        }
        else {
            if oauthClient.redirectUri != redirectUri {
                throw User.OauthError.invalidRedirectURI
            }

        }

        // exchange
        if grantType == nil && scope != "profile" {
            throw User.OauthError.invalidScope
        }
        return oauthClient.loginRedirectUri
    }

    func getCode(_ request: User.Oauth.AuthorizationPostRequest) async throws
        -> String
    {

        let db = try await components.database().connection()

        // check account
        guard
            (try await User.Account.Query.get(request.accountId.toKey(), on: db))
                != nil
        else {
            throw User.OauthError.unauthorizedClient
        }

        // create and save new code
        let detail = try await user.authorizationCode.create(
            .init(
                accountId: request.accountId,
                clientId: request.clientId,
                redirectUri: request.redirectUri,
                scope: request.scope,
                state: request.state
            )
        )

        return detail.value
    }

    func getJWT(_ request: User.Oauth.JwtRequest) async throws
        -> User.Oauth.JwtResponse
    {
        let db = try await components.database().connection()
        let interval = 604800

        // check if client exist in db
        guard
            let oauthClient = try await User.OauthClient.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: request.clientId
                ),
                on: db
            )
        else {
            throw User.OauthError.unauthorizedClient
        }

        // code exchange
        guard request.grantType == .authorization else {

            // create jwt
            let keyCollection = try await getKeyCollection(oauthClient)
            let payload = User.Oauth.Payload(
                iss: IssuerClaim(value: oauthClient.issuer),
                sub: SubjectClaim(value: oauthClient.id.rawValue),
                aud: AudienceClaim(value: oauthClient.audience),
                // 1 week
                exp: ExpirationClaim(
                    value: Date().addingTimeInterval(TimeInterval(interval))
                )
            )
            let jwt = try await keyCollection.sign(payload)

            return .init(
                accessToken: jwt,
                tokenType: "Bearer",
                expiresIn: interval,
                scope: "server"
            )
        }

        // check if code exist in db
        guard
            let authorizationCode = try await User.AuthorizationCode.Query
                .getFirst(
                    filter: .init(
                        column: .value,
                        operator: .equal,
                        value: request.code
                    ),
                    on: db
                )
        else {
            throw User.OauthError.invalidGrant
        }

        // validate code, delete it if error
        if !validateCode(
            authorizationCode,
            request.clientId,
            request.redirectUri
        ) {
            try await deleteCode(authorizationCode.value, db)
            throw User.OauthError.invalidGrant
        }

        // delete code so it can not be used again
        try await deleteCode(authorizationCode.value, db)

        // check account
        guard
            let account = try await User.Account.Query.get(
                authorizationCode.accountId,
                on: db
            )
        else {
            throw User.OauthError.unauthorizedClient
        }

        // create jwt
        let keyCollection = try await getKeyCollection(oauthClient)
        let data = try await account.id.toID()
            .getRolesAndPermissonsForId(user, db)

        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: oauthClient.issuer),
            sub: SubjectClaim(value: oauthClient.subject),
            aud: AudienceClaim(value: oauthClient.audience),
            // 1 week
            exp: ExpirationClaim(
                value: Date().addingTimeInterval(TimeInterval(interval))
            ),
            accountId: authorizationCode.accountId.toID(),
            roles: data.0.map { $0.key.rawValue },
            permissions: data.1.map { $0.rawValue }
        )
        let jwt = try await keyCollection.sign(payload)

        return .init(
            accessToken: jwt,
            tokenType: "Bearer",
            expiresIn: interval,
            scope: "profile"
        )
    }

    private func getKeyCollection(_ oauthClient: User.OauthClient.Query.Row)
        async throws -> JWTKeyCollection
    {
        let privateKey = try EdDSA.PrivateKey(
            d: oauthClient.privateKey,
            curve: .ed25519
        )
        return await JWTKeyCollection().add(eddsa: privateKey)
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

    // valides a code before exchange
    private func validateCode(
        _ code: User.AuthorizationCode.Model,
        _ clientId: String,
        _ redirectUri: String?
    ) -> Bool {
        if code.clientId != clientId {
            return false
        }
        else if code.redirectUri != redirectUri {
            return false
        }
        else if code.expiration < Date() {
            return false
        }
        return true
    }

}
