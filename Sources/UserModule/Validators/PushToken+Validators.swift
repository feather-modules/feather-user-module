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

    func validate() async throws {
        let v = GroupValidator {
            User.PushToken.Validators.token(token)
        }
        try await v.validate()
    }
}

extension User.PushToken.Update {

    func validate() async throws {
        let v = GroupValidator {
            User.PushToken.Validators.token(token)
        }
        try await v.validate()
    }
}
