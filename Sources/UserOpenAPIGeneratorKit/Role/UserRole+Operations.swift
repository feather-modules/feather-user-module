import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Role {

    enum Operations {

        enum List: Operation {
            static let security: [SecurityScheme.Type] = .shared
            static let tag: Tag.Type = Tags.Main.self
            static let summary = "List User Roles"
            static let description = "List available User Roles"
            static let parameters: [Parameter.Type] =
                [
                    Parameters.List.Sort.self
                ] + Generic.Component.Parameters.List.parameters
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
            static let summary = "Create a User Role"
            static let description = "Creates a new User Role"
            static let requestBody: RequestBody.Type? = RequestBodies.Create
                .self
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
            static let summary = "Bulk delete User Roles"
            static let description = "Removes multiple User Roles at once"
            static let requestBody: RequestBody.Type? = RequestBodies.BulkDelete
                .self
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
            static let summary = "User Role details"
            static let description = "Get the details of a User Role"
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
            static let summary = "Update a User Role"
            static let description = "Updates a User Role"
            static let parameters: [Parameter.Type] = [
                Parameters.Key.self
            ]
            static let requestBody: RequestBody.Type? = RequestBodies.Update
                .self
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
            static let summary = "Patch a User Role"
            static let description = "Patch a given User Role"
            static let parameters: [Parameter.Type] = [
                Parameters.Key.self
            ]
            static let requestBody: RequestBody.Type? = RequestBodies.Patch.self
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
