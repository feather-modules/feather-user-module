import Foundation
import JWTKit
import UserModuleKit
import XCTest

let eddsaPrivateKeyBase64: String =
    "eERFYmk5bXJobGVBdFg0aDlWOVUzSXVkUVc1dWdBekQ="
let eddsaPublicKeyBase64: String =
    "dFFXbkxJbk04NnVUcU1EOUNIV1ZEZ3NRRXRXSTJvbXA="
let kid = "C0DNaksMD3nOYLpddFSvkrlDFVKKzRKL"

final class JWTTests: XCTestCase {

    func testSign() async throws {

        let publicKey = try EdDSA.PublicKey(
            x: eddsaPublicKeyBase64,
            curve: .ed25519
        )
        let privateKey = try EdDSA.PrivateKey(
            d: eddsaPrivateKeyBase64,
            curve: .ed25519
        )

        let keyCollection = await JWTKeyCollection()
            .add(eddsa: privateKey, kid: .init(string: kid))
            .add(eddsa: publicKey, kid: .init(string: kid))

        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: "issuer"),
            sub: SubjectClaim(value: "subject"),
            aud: AudienceClaim(value: ["audience"]),
            exp: ExpirationClaim(value: Date().addingTimeInterval(60))
        )
        _ = try await keyCollection.sign(payload)
    }

    func testSignAndJWTVerify() async throws {
        let publicKey = try EdDSA.PublicKey(
            x: eddsaPublicKeyBase64,
            curve: .ed25519
        )
        let privateKey = try EdDSA.PrivateKey(
            d: eddsaPrivateKeyBase64,
            curve: .ed25519
        )

        let keyCollection = await JWTKeyCollection()
            .add(eddsa: privateKey, kid: .init(string: kid))
            .add(eddsa: publicKey, kid: .init(string: kid))

        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: "issuer"),
            sub: SubjectClaim(value: "subject"),
            aud: AudienceClaim(value: ["audience"]),
            exp: ExpirationClaim(value: Date().addingTimeInterval(60))
        )
        let jwt = try await keyCollection.sign(payload)

        let jwksString = """
            {
                "keys": [
                    {
                        "kty": "OKP",
                        "crv": "Ed25519",
                        "use": "sig",
                        "kid": "\(kid)",
                        "x": "\(eddsaPublicKeyBase64)",
                    }
                ]
            }
            """
        let verifier = await JWTKeyCollection()
            .add(eddsa: privateKey, kid: .init(string: kid))
        try await verifier.use(jwksJSON: jwksString)
        _ = try await verifier.verify(jwt, as: User.Oauth.Payload.self)
    }

}
