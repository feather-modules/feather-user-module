import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Push {

    enum Schemas {

        enum Id: UUIDSchema {
            static let description = "Unique user push identifier"
        }

        enum Platform: EnumSchema {
            static let description = "User device platform type"
            static let allowedValues = ["android", "ios"]
            static let examples = [
                "ios"
            ]
        }

        enum Token: TextSchema {
            static let description = "Push token value"
            static let examples = [
                "pjZwJnl7lFIAkyXsvxlni16VHcdGQKlhd8AMh6wSRCRFyHCQrZpwBWesMdH8jSD6"
            ]
        }

        // MARK: -

        enum Reference: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("id", Id.self),
                .init("token", Token.self),
            ]
        }

        enum Detail: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("id", Id.self),
                .init("accountId", User.Account.Schemas.Id.self),
                .init("platform", Platform.self),
                .init("token", Token.self),
            ]
        }

        enum Create: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("platform", Platform.self),
                .init("token", Token.self),
            ]
        }

        enum Update: ObjectSchema {
            static let description = ""
            static let properties: [ObjectSchemaProperty] = [
                .init("token", Token.self)
            ]
        }
    }
}
