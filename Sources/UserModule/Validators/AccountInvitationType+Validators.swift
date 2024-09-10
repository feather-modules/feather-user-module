import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountInvitationType {
    enum Validators {
        static func title(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "title",
                value: value,
                rules: [
                    .min(length: 3),
                    .max(length: 64),
                ]
            )
        }
    }
}

extension User.AccountInvitationType.Create {

    public func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.AccountInvitationType.Validators.title(title)
        }
        try await v.validate()
    }
}
