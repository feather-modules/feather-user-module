import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Password {

    enum Operations {

        enum Reset: Operation {
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Initiate a reset password flow"
            static let description = """
                Send out a reset password email with a password reset token if the given email has an associated user account.
                """
            static let requestBody: RequestBody.Type? = RequestBodies.Reset.self
            static let responses: [OperationResponse] = [
                .noContent,
                .badRequest,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }

        enum Set: Operation {
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Set new password"
            static let description = """
                Set a new password for the user account using a password reset token.
                """
            static let parameters: [Parameter.Type] = [
                Parameters.Token.self
            ]
            static let requestBody: RequestBody.Type? = RequestBodies.Set.self
            static let responses: [OperationResponse] = [
                .noContent,
                .badRequest,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }
    }
}
