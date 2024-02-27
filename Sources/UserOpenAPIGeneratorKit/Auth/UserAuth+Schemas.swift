import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Auth {

    enum Schemas {

        enum Email: EmailSchema {
            static let description = "Email address of the user"
            static let examples = [
                "info@avalliance.com"
            ]
        }

        enum Password: PasswordSchema {
            static let description = "Password of the user"
            static let examples = [
                "ChangeMe1"
            ]
        }

        // MARK: - token

        enum Value: TextSchema {
            static let description = "User auth token"
            static let examples = [
                "pjZwJnl7lFIAkyXsvxlni16VHcdGQKlhd8AMh6wSRCRFyHCQrZpwBWesMdH8jSD6"
            ]
        }

        enum Expiration: DateTimeSchema {
            static let description = "Expiration of the auth token"
            static let examples = [
                "2023-02-10T09:20:15.393Z"
            ]
        }

        enum Request: ObjectSchema {
            static let description = "User auth request"
            static let properties: [ObjectSchemaProperty] = [
                .init("email", Email.self),
                .init("password", Password.self),
            ]
        }

        enum Roles: ArraySchema {
            static let items: Schema.Type = User.Role.Schemas.Reference.self
            static let description = ""
        }

        enum Response: ObjectSchema {
            static let description = "User auth response"
            static let properties: [ObjectSchemaProperty] = [
                .init("account", User.Account.Schemas.Detail.self),
                .init("token", Token.self),
                .init("roles", Roles.self),
            ]
        }

        enum Token: ObjectSchema {
            static let description = "User auth token details"
            static let properties: [ObjectSchemaProperty] = [
                .init("value", Value.self),
                .init("expiration", Expiration.self),
            ]
        }

    }
}
