import FeatherOpenAPIKit

extension User.Password {

    enum Parameters {

        enum Token: QueryParameter {
            static let name = "token"
            static let description = "The password reset token"
            static let schema: Schema.Type = Schemas.Token.self
        }
    }
}
