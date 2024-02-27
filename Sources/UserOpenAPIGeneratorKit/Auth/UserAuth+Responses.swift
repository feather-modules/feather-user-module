import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Auth {

    enum Responses {

        enum Response: JSONResponse {
            static let description = "Sign in response object"
            static let schema: Schema.Type = Schemas.Response.self
        }

    }
}
