//import NIOFoundationCompat
import Foundation
import HTTPTypes
import NIOCore
import OpenAPIRuntime
import UserKit
import UserOpenAPIRuntimeKit

extension CodingKey {
    /// returns a coding key as a path key string.
    fileprivate var pathKeyValue: String {
        if let value = intValue {
            return String(value)
        }
        return stringValue
    }
}

extension Array where Element == CodingKey {
    /// returns a path key using a dot character as a separator.
    fileprivate var pathKeyValue: String {
        map(\.pathKeyValue).joined(separator: ".")
    }
}

public struct ServerErrorMiddleware: ServerMiddleware {

    public init() {
        // nothing to do here...
    }

    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, ServerRequestMetadata)
            async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        do {
            return try await next(request, body, metadata)
        }
        catch let error as OpenAPIRuntime.ServerError {
            switch error.underlyingError {
            case let error as DecodingError:
                return try await handleDecodingError(error)
            case let error as UserSDKError:
                return try await handleSDKError(error)
            default:
                return try await handleUnderlyingError(
                    request,
                    error.underlyingError
                )
            }
        }
        catch {
            return try internalServerError(error)
        }
    }

    // MARK: - error handlers

    func handleSDKError(
        _ error: UserSDKError
    ) async throws -> (HTTPResponse, HTTPBody?) {
        switch error {
        case .unknown:
            return try internalServerError(error)
        case .database(let error):
            return try internalServerError(error)
        //        case .unauthorized(let state):
        //            switch state {
        //            case .credentials:
        //                return try unauthorizedResponse(
        //                    .init(
        //                        key: .invalidUserToken,  // TODO: enum case
        //                        message: "Invalid user credentials."
        //                    )
        //                )
        //            case .token:
        //                return try unauthorizedResponse(
        //                    .init(
        //                        key: .invalidUserToken,
        //                        message: "Invalid user token."
        //                    )
        //                )
        //            case .any:
        //                return try unauthorizedResponse(
        //                    .init(
        //                        key: .invalidUserToken,  // TODO: enum case
        //                        message: "User is not authorized."
        //                    )
        //                )
        //            }
        //
        //        case .forbidden(let info):
        //            return try forbiddenResponse(
        //                .init(
        //                    key: info.key,
        //                    message: "User has no \(info.kind)."
        //                )
        //            )
        case .validation(let failures):
            return try unprocessableContentResponse(
                .init(
                    key: .validation,
                    message: "Validation error",
                    failures: failures.map {
                        .init(
                            key: $0.key,
                            message: $0.message
                        )
                    }
                )
            )
        }
    }

    func handleUnderlyingError(
        _ request: HTTPRequest,
        _ error: Error
    ) async throws -> (HTTPResponse, HTTPBody?) {
        switch "\(type(of: error))" {
        case "RuntimeError":
            if "\(error)".hasPrefix("Unexpected Content-Type header: ") {
                let key = request.headerFields[.contentType] ?? "unknown"
                return try unsupportedMediaTypeResponse(
                    .init(key: key, message: "\(error)")
                )
            }
            if "\(error)".hasPrefix("Unexpected Accept header: ") {
                let key = request.headerFields[.accept] ?? "unknown"
                return try notAcceptableResponse(
                    .init(key: key, message: "\(error)")
                )
            }
        default:
            break
        }
        return try internalServerError(error)
    }

    func handleDecodingError(
        _ error: DecodingError
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var message = "Unknown decoding error"
        switch error {
        case DecodingError.dataCorrupted(let context):
            //            var details: [String: String] = [:]
            //            for codingPath in context.codingPath {
            //                details[codingPath.pathKeyValue] = context.debugDescription
            //            }
            message = context.debugDescription
        case DecodingError.keyNotFound(let key, _):
            let path = key.pathKeyValue
            message = "Coding key `\(path)` not found."
        case DecodingError.valueNotFound(_, let context):
            let path = context.codingPath.pathKeyValue
            message = "Value not found for `\(path)` key."
        case DecodingError.typeMismatch(let type, let context):
            let path = context.codingPath.pathKeyValue
            message =
                "Type mismatch for `\(path)` key, expected `\(type)` type."
        @unknown default:
            break
        }
        return try badRequestResponse(
            .init(
                key: .invalidRequestBody,
                message: message
            )
        )
    }

    // MARK: - responses

    func jsonResponse<T: Encodable>(
        _ status: HTTPResponse.Status,
        _ encodable: T
    ) throws -> (HTTPResponse, HTTPBody?) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .sortedKeys
        ]
        let data = try encoder.encode(encodable)
        return (
            .init(
                status: status,
                headerFields: [
                    .contentType: "application/json; charset=utf-8"
                ]
            ),
            .init([UInt8](data))
        )
    }

    // MARK: - error responses

    func badRequestResponse(
        _ error: Components.Schemas.GenericBadRequestError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.badRequest, error)
    }

    func conflictResponse(
        _ error: Components.Schemas.GenericConflictError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.conflict, error)
    }

    func forbiddenResponse(
        _ error: Components.Schemas.GenericForbiddenError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.forbidden, error)
    }

    func goneResponse(
        _ error: Components.Schemas.GenericGoneError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.gone, error)
    }

    func methodNotAllowedResponse(
        _ error: Components.Schemas.GenericMethodNotAllowedError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.methodNotAllowed, error)
    }

    func notAcceptableResponse(
        _ error: Components.Schemas.GenericNotAcceptableError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.notAcceptable, error)
    }

    func notFoundResponse(
        _ error: Components.Schemas.GenericNotFoundError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.notFound, error)
    }

    func unauthorizedResponse(
        _ error: Components.Schemas.GenericUnauthorizedError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.unauthorized, error)
    }

    func unprocessableContentResponse(
        _ error: Components.Schemas.GenericUnprocessableContentError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.unprocessableContent, error)
    }

    func unsupportedMediaTypeResponse(
        _ error: Components.Schemas.GenericUnsupportedMediaTypeError
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(.unsupportedMediaType, error)
    }

    func internalServerError(
        _ error: Error
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(
            .internalServerError,
            Components.Schemas.GenericInternalServerErrorError(
                key: "internal-server-error",
                message: "\(error)"
            )
        )
    }

}
