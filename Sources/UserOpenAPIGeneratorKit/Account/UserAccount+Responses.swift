import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Account {

    enum Responses {

        enum Detail: JSONResponse {
            static let description = "User Account detail object"
            static let schema: Schema.Type = Schemas.Detail.self
        }

        enum List: JSONResponse {
            static let description = "User Account list object"
            static let schema: Schema.Type = Schemas.List.self
        }
    }
}
