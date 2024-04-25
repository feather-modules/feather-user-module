import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import UserModuleKit

extension User.PushToken {

    enum Validators {
        static func token(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "token",
                value: value,
                rules: [
                    .nonempty()
                ]
            )
        }
    }

}

extension User.PushToken.Create {

    public func validate(on db: Database) async throws {
        let v = GroupValidator {
            User.PushToken.Validators.token(token)
        }
        try await v.validate()
    }
}

extension User.PushToken.Update {

    public func validate(
        _ originalKey: ID<User.Account>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.PushToken.Validators.token(token)
        }
        try await v.validate()
    }
}
