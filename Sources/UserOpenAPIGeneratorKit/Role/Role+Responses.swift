import FeatherOpenAPIKit

extension User.Role {

    enum Responses {

        enum List: JSONResponse {
            static let description = "User Role list object"
            static let schema: Schema.Type = Schemas.List.self
        }

        enum Detail: JSONResponse {
            static let description = "User Role detail object"
            static let schema: Schema.Type = Schemas.Detail.self
        }
    }
}
