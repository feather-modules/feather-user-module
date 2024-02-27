import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Push {

    enum Parameters {

        enum Id: PathParameter {
            static let name = "pushId"
            static let description = "User push identifier"
            static let schema: Schema.Type = Schemas.Id.self
        }

    }
}
