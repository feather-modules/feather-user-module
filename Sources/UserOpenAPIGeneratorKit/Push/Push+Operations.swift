import FeatherOpenAPIKit

extension User.Push {

    enum Operations {

        enum Create: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Create a push token object"
            static let description = "Create a push token object"
            static let requestBody: RequestBody.Type? = RequestBodies.Create
                .self
            static let responses: [OperationResponse] = [
                .ok(Responses.Create.self),
                .badRequest,
                .unauthorized,
                .forbidden,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }

        // MARK: -

        enum Update: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Updates a push token object"
            static let description = "Updates a push token object"
            static let parameters: [Parameter.Type] = [
                Parameters.Id.self
            ]
            static let requestBody: RequestBody.Type? = RequestBodies.Update
                .self
            static let responses: [OperationResponse] = [
                .ok(Responses.Update.self),
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }

        enum Delete: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Delete a push token object"
            static let description = "Delete a push token object"
            static let parameters: [Parameter.Type] = [
                Parameters.Id.self
            ]
            static let responses: [OperationResponse] = [
                .noContent,
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
            ]
        }
    }
}
