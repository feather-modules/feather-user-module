import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Password {

    enum Responses {

        enum Reset: JSONResponse {
            static let description = "Initiate a reset password flow"
            static let schema: Schema.Type = Schemas.Reset.self
        }

        enum Set: JSONResponse {
            static let description = "Set new password"
            static let schema: Schema.Type = Schemas.Set.self
        }
    }
}
