import CoreOpenAPIGeneratorKit
import FeatherOpenAPIKit

extension User.Account {

    public enum Schemas {

        public enum Id: IDSchema {
            public static let description = "Unique user account identifier"
        }

        public enum Email: EmailSchema {
            public static let description = "E-mail address of the user"
            public static let examples = [
                "info@binarybirds.com"
            ]
        }

        public enum Password: PasswordSchema {
            public static let description = "Password of the user"
            public static let examples = [
                "ChangeMe1"
            ]
        }

        public enum Roles: ArraySchema {
            public static let description = "User roles"
            public static let items: Schema.Type = User.Role.Schemas.Reference
                .self
        }

        public enum RoleKeys: ArraySchema {
            public static let description = "User role keys"
            public static let items: Schema.Type = User.Role.Schemas.Key.self
        }

        // MARK: - list

        public enum List: ObjectSchema {

            public enum Item: ObjectSchema {
                public static let description = "User account list item"
                public static let properties: [ObjectSchemaProperty] = [
                    .init("id", Id.self),
                    .init("email", Email.self),
                ]
            }

            public enum Items: ArraySchema {
                public static let description = "User account list items"
                public static let items: Schema.Type = Item.self
            }

            public enum Sort: EnumSchema {
                public static let description = "The sort key for the list"
                public static let allowedValues = ["email"]
                public static let defaultValue = "email"
            }

            public static let description = "User account list"
            public static let properties: [ObjectSchemaProperty] =
                [
                    .init("items", Items.self),
                    .init("sort", Sort.self, required: false),
                ] + Feather.Core.Schemas.List.properties
        }

        // MARK: -

        public enum Reference: ObjectSchema {
            public static let description = ""
            public static let properties: [ObjectSchemaProperty] = [
                .init("id", Id.self),
                .init("email", Email.self),
            ]
        }

        public enum Detail: ObjectSchema {
            public static let description = ""
            public static let properties: [ObjectSchemaProperty] = [
                .init("id", Id.self),
                .init("email", Email.self),
                .init("roles", Roles.self),
            ]
        }

        public enum BulkDelete: ArraySchema {
            public static let description = "The list of the ids to be deleted."
            public static let items: Schema.Type = Id.self
        }

        public enum Create: ObjectSchema {
            public static let description = ""
            public static let properties: [ObjectSchemaProperty] = [
                .init("email", Email.self),
                .init("password", Password.self),
                .init("roleKeys", RoleKeys.self),
            ]
        }

        public enum Update: ObjectSchema {
            public static let description = ""
            public static let properties: [ObjectSchemaProperty] = [
                .init("email", Email.self),
                .init("password", Password.self, required: false),
                .init("roleKeys", RoleKeys.self),
            ]
        }

        public enum Patch: ObjectSchema {
            public static let description = ""
            public static let properties: [ObjectSchemaProperty] = [
                .init("email", Email.self, required: false),
                .init("password", Password.self, required: false),
                .init("roleKeys", RoleKeys.self, required: false),
            ]
        }
    }
}
