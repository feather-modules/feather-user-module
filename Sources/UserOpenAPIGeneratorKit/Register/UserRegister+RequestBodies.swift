import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Register {

    enum RequestBodies {

        enum Post: JSONBody {
            static let description = "Register account request body"
            static let schema: Schema.Type = User.Account.Schemas.Create.self
        }
    }
}
