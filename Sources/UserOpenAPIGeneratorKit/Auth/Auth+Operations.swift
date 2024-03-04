import FeatherOpenAPIKit

extension User.Auth {

    enum Operations {

        enum Post: Operation {
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Sign in"
            static let description = "Sign in with an existing user account"
            static let requestBody: RequestBody.Type? = RequestBodies.Request
                .self
            static let responses: [OperationResponse] = [
                .ok(Responses.Response.self),
                .badRequest,
                .unauthorized,
                .forbidden,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }

        enum Delete: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Sign out"
            static let description = "Sign out using an existing token"
            static let responses: [OperationResponse] = [
                .noContent,
                .badRequest,
                .unauthorized,
                .forbidden,
            ]
        }
    }
}
