import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Password {

    enum RequestBodies {

        enum Reset: JSONBody {
            static let description = "Reset password request body"
            static let schema: Schema.Type = Schemas.Reset.self
        }

        enum Set: JSONBody {
            static let description = "Set new password request body"
            static let schema: Schema.Type = Schemas.Set.self
        }
    }
}
