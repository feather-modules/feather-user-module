import FeatherOpenAPIKit

extension User.Register {

    enum Responses {

        enum Post: JSONResponse {
            static let description = "Register a new user account"
            static let schema: Schema.Type = User.Auth.Schemas.Response.self
        }
    }
}
