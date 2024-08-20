import JWTKit
import XCTest
import Foundation
import UserModuleKit

final class JWTTests: XCTestCase {
    
    func test() async throws {
        
        /*let keys = JWTKeyCollection()
        await keys.add(hmac: "secret", digestAlgorithm: .sha512, kid: "kid")
        
        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: "String"),
            sub: SubjectClaim(value: "String"),
            aud: AudienceClaim(value: ["String"]),
            exp: ExpirationClaim(value: Date().addingTimeInterval(12000000)),
            accountId:.init(rawValue: "asdasd")

        )
        let jwt = try await keys.sign(payload, kid: "kid")
        
        let verify = try await keys.verify(jwt, as: User.Oauth.Payload.self)
        
        print(verify)*/
        
        /*
        
        //let eddsaPrivateKeyBase64: String = .generateToken(32).data(using: .utf8)!.base64EncodedString()
        //let eddsaPublicKeyBase64: String = .generateToken(32).data(using: .utf8)!.base64EncodedString()
        
        let eddsaPrivateKeyBase64: String = "eERFYmk5bXJobGVBdFg0aDlWOVUzSXVkUVc1dWdBekQ="
        let eddsaPublicKeyBase64: String = "dFFXbkxJbk04NnVUcU1EOUNIV1ZEZ3NRRXRXSTJvbXA="
        let kid = "C0DNaksMD3nOYLpddFSvkrlDFVKKzRKL"
        
        
        let publicKey = try EdDSA.PublicKey(x: eddsaPublicKeyBase64, curve: .ed25519)
        let privateKey = try EdDSA.PrivateKey(d: eddsaPrivateKeyBase64, curve: .ed25519)
        
        let keyCollection = await JWTKeyCollection()
            .add(eddsa: privateKey, kid: .init(string: kid))
            //.add(eddsa: publicKey, kid: "public")
            
        
        
        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: "String"),
            sub: SubjectClaim(value: "String"),
            aud: AudienceClaim(value: ["String"]),
            exp: ExpirationClaim(value: Date().addingTimeInterval(12000000))
        )
        let jwt = try await keyCollection.sign(payload)
        
        print(jwt)
        
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
        
    
        let verify = try await verifier.verify(jwt, as: User.Oauth.Payload.self)
        
        print(verify)*/
    }
    
    
}
