import FeatherOpenAPIKit

extension User.Push {

    enum RequestBodies {

        enum Create: JSONBody {
            static let description = "Create push token request body"
            static let schema: Schema.Type = Schemas.Create.self
        }

        enum Update: JSONBody {
            static let description = "Update push token request body"
            static let schema: Schema.Type = Schemas.Update.self
        }
    }
}
