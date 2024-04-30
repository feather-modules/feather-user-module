import FeatherModuleKit
import FeatherValidation
import UserModuleKit

extension User.Password {

    enum Validators {
        static func password(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "password",
                value: value,
                rules: [
                    .password()
                ]
            )
        }
    }

}

extension User.Password.Set {
    func validate() async throws {
        let v = GroupValidator {
            User.Password.Validators.password(password)
        }
        try await v.validate()
    }
}
