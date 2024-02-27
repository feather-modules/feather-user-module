import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Push {

    enum Responses {

        enum Create: JSONResponse {
            static let description = "Create a push token object"
            static let schema: Schema.Type = Schemas.Create.self
        }

        enum Update: JSONResponse {
            static let description = "Updates a push token object"
            static let schema: Schema.Type = Schemas.Update.self
        }

    }
}
