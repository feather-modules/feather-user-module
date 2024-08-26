import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import UserModuleKit

extension User.OauthClient {

    enum Validators {
        static func checkLength(
            _ key: Model.CodingKeys,
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: key.rawValue,
                value: value,
                rules: [
                    .min(length: 3),
                    .max(length: 64),
                ]
            )
        }

        static func uniqueKey(
            _ key: Model.CodingKeys,
            _ value: String,
            _ originalValue: String? = nil,
            on db: Database
        ) -> Validator {
            KeyValueValidator(
                key: key.rawValue,
                value: value,
                rules: [
                    .unique(
                        Query.self,
                        column: key,
                        originalValue: originalValue,
                        on: db
                    )
                ]
            )
        }
    }
}

extension User.OauthClient.Create {

    func validate(on db: Database) async throws {
        let v = GroupValidator {
            User.OauthClient.Validators.checkLength(.name, name)
            User.OauthClient.Validators.uniqueKey(.name, name, on: db)
            User.OauthClient.Validators.checkLength(.type, type.rawValue)
            User.OauthClient.Validators.checkLength(.redirectUrl, redirectUrl)
            User.OauthClient.Validators.checkLength(.issuer, issuer)
            User.OauthClient.Validators.checkLength(.subject, subject)
            User.OauthClient.Validators.checkLength(.audience, audience)
        }
        try await v.validate()
    }

}

extension User.OauthClient.Update {

    func validate(
        _ originalName: String,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.OauthClient.Validators.checkLength(.name, name)
            User.OauthClient.Validators.uniqueKey(
                .name,
                name,
                originalName,
                on: db
            )
            User.OauthClient.Validators.checkLength(.type, type.rawValue)
            User.OauthClient.Validators.checkLength(.redirectUrl, redirectUrl)
            User.OauthClient.Validators.checkLength(.issuer, issuer)
            User.OauthClient.Validators.checkLength(.subject, subject)
            User.OauthClient.Validators.checkLength(.audience, audience)
        }
        try await v.validate()
    }
}

extension User.OauthClient.Patch {

    func validate(
        _ originalName: String?,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            if let name {
                User.OauthClient.Validators.checkLength(.name, name)
                User.OauthClient.Validators.uniqueKey(
                    .name,
                    name,
                    originalName,
                    on: db
                )
            }
            if let type {
                User.OauthClient.Validators.checkLength(.type, type.rawValue)
            }
            if let redirectUrl {
                User.OauthClient.Validators.checkLength(
                    .redirectUrl,
                    redirectUrl
                )
            }
            if let issuer {
                User.OauthClient.Validators.checkLength(.issuer, issuer)
            }
            if let subject {
                User.OauthClient.Validators.checkLength(.subject, subject)
            }
            if let audience {
                User.OauthClient.Validators.checkLength(.audience, audience)
            }
        }
        try await v.validate()
    }
}
