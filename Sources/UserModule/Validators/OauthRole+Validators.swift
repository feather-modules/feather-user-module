import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import UserModuleKit

extension User.OauthRole {

    enum Validators {

        static func uniqueKey(
            _ value: ID<User.OauthRole>,
            on db: Database,
            _ originalKey: ID<User.OauthRole>? = nil
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .unique(
                        Query.self,
                        column: .key,
                        originalValue: originalKey,
                        on: db
                    )
                ]
            )
        }

        static func key(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .nonempty(),
                    .min(length: 3),
                    .max(length: 64),
                ]
            )
        }
    }
}

extension User.OauthRole.Create {

    func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.OauthRole.Validators.key(key.rawValue)
            User.OauthRole.Validators.uniqueKey(key, on: db)
        }
        try await v.validate()
    }
}

extension User.OauthRole.Update {

    func validate(
        _ originalKey: ID<User.OauthRole>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.OauthRole.Validators.key(key.rawValue)
            User.OauthRole.Validators.uniqueKey(
                key,
                on: db,
                originalKey
            )
        }
        try await v.validate()
    }
}

extension User.OauthRole.Patch {

    func validate(
        _ originalKey: ID<User.OauthRole>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            if let key {
                User.OauthRole.Validators.key(key.rawValue)
                User.OauthRole.Validators.uniqueKey(
                    key,
                    on: db,
                    originalKey
                )
            }
        }
        try await v.validate()
    }
}
