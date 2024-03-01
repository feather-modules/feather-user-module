import CoreOpenAPIGeneratorKit
import FeatherOpenAPIKit

extension User.Account {

    enum Operations {

        enum Me: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Current user account details"
            static let description = """
                Get the details of the currently logged in user account based on the auth token.
                """
            static let responses: [OperationResponse] = [
                .ok(Responses.Detail.self),
                .unauthorized,
            ]
        }

        enum List: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "List User Accounts"
            static let description = "List available User Accounts"
            static let parameters: [Parameter.Type] =
                [
                    Parameters.List.Sort.self
                ] + Feather.Core.Parameters.List.parameters
            static let responses: [OperationResponse] = [
                .ok(Responses.List.self),
                .badRequest,
                .unauthorized,
                .forbidden,
            ]
        }

        enum Create: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Create a User Account"
            static let description = "Creates a new User Account"
            static let requestBody: RequestBody.Type? = RequestBodies
                .Create.self
            static let responses: [OperationResponse] = [
                .ok(Responses.Detail.self),
                .badRequest,
                .unauthorized,
                .forbidden,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }

        enum BulkDelete: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Bulk delete User Accounts"
            static let description = "Removes multiple User Accounts at once"
            static let requestBody: RequestBody.Type? = RequestBodies
                .BulkDelete.self
            static let responses: [OperationResponse] = [
                .noContent,
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }

        // MARK: -

        enum Detail: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "User Account details"
            static let description = "Get the details of a User Account"
            static let responses: [OperationResponse] = [
                .ok(Responses.Detail.self),
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
            ]
        }

        enum Update: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Update a User Account"
            static let description = "Updates a User Account"
            static let requestBody: RequestBody.Type? = RequestBodies
                .Update.self
            static let responses: [OperationResponse] = [
                .ok(Responses.Detail.self),
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }

        enum Patch: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "Patch a User Account"
            static let description = "Patch a given User Account"
            static let requestBody: RequestBody.Type? = RequestBodies
                .Patch.self
            static let responses: [OperationResponse] = [
                .ok(Responses.Detail.self),
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .unsupportedMediaType,
                .unprocessableContent,
            ]
        }
    }
}
