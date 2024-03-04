import FeatherOpenAPIKit
import OpenAPIKit

extension User.Password {

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

        // MARK: -

        enum Reset: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("email", Email.self)
            ]
        }

        enum Set: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("password", Password.self)
            ]
        }

        enum Token: TextSchema {
            static let description = "The password reset token"
            static let examples = [
                "uuimnfzda8b35r2o1wnadx4hq3p46vzo02u5fx9vitgrmlgbgeasz5d3lvz7d8rq"
            ]
        }
    }
}
