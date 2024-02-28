import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Account {

    enum Schemas {

        enum Id: IDSchema {
            static let description = "Unique user account identifier"
        }

        enum Email: EmailSchema {
            static let description = "E-mail address of the user"
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
        
        enum Roles: ArraySchema {
            static let description = "User roles"
            static let items: Schema.Type = User.Role.Schemas.Reference.self
        }
        
        enum RoleKeys: ArraySchema {
            static let description = "User role keys"
            static let items: Schema.Type = User.Role.Schemas.Key.self
        }

        // MARK: - list

        enum List: ObjectSchema {

            enum Item: ObjectSchema {
                static let description = "User account list item"
                static let properties: [ObjectSchemaProperty] = [
                    .init("id", Id.self),
                    .init("email", Email.self),
                ]
            }

            enum Items: ArraySchema {
                static let description = "User account list items"
                static let items: Schema.Type = Item.self
            }

            enum Sort: EnumSchema {
                static let description = "The sort key for the list"
                static let allowedValues = ["email"]
                static let defaultValue = "email"
            }

            static let description = "User account list"
            static let properties: [ObjectSchemaProperty] =
                [
                    .init("items", Items.self),
                    .init("sort", Sort.self, required: false),
                ] + Generic.Component.Schemas.List.properties
        }

        // MARK: -

        enum Reference: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("id", Id.self),
                .init("email", Email.self),
            ]
        }

        enum Detail: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("id", Id.self),
                .init("email", Email.self),
                .init("roles", Roles.self, required: false),
            ]
        }

        enum BulkDelete: ArraySchema {
            static let description = "The list of the ids to be deleted."
            static let items: Schema.Type = Id.self
        }

        enum Create: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("email", Email.self),
                .init("password", Password.self),
            ]
        }

        enum Update: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("email", Email.self),
                .init("password", Password.self, required: false),
                .init("roleKeys", RoleKeys.self, required: false),
            ]
        }

        enum Patch: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("email", Email.self, required: false),
                .init("password", Password.self, required: false),
                .init("roleKeys", RoleKeys.self, required: false),
            ]
        }
    }
}
