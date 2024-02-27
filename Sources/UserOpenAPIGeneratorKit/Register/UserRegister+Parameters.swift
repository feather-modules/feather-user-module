import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Register {

    enum Parameters {

        enum Token: QueryParameter {
            static let name = "token"
            static let description = "The invitation token"
            static let schema: Schema.Type = Schemas.Token.self
        }
    }
}
