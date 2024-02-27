import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Auth {

    enum RequestBodies {

        enum Request: JSONBody {
            static let description = "Sign in request body"
            static let schema: Schema.Type = Schemas.Request.self
        }
    }
}
