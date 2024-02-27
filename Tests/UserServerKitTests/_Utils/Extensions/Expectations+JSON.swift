import FeatherOpenAPISpec
import HTTPTypes
import NIOCore
import NIOFoundationCompat
import OpenAPIRuntime
import UserOpenAPIRuntimeKit
import XCTest

extension HTTPBody {

    func collect() async throws -> ByteBuffer {
        var buffer = ByteBuffer()
        switch length {
        case .known(let value):
            try await collect(upTo: Int(value), into: &buffer)
        case .unknown:
            for try await chunk in self {
                buffer.writeBytes(chunk)
            }
        }
        return buffer
    }
}

extension ByteBuffer {

    var stringValue: String? {
        getString(at: 0, length: readableBytes)
    }
}

// MARK: - request method helpers

public struct BearerToken: SpecBuilderParameter {
    let token: String

    public init(
        _ token: String
    ) {
        self.token = token
    }

    public func build(_ spec: inout Spec) {
        spec.setHeader(.authorization, "Bearer \(token)")
    }
}

public struct GET: SpecBuilderParameter {
    let path: String?

    public init(
        _ path: String? = nil
    ) {
        self.path = path
    }

    public func build(_ spec: inout Spec) {
        spec.setMethod(.get)
        spec.setPath(path)
    }
}

public struct POST: SpecBuilderParameter {
    let path: String?

    public init(
        _ path: String? = nil
    ) {
        self.path = path
    }

    public func build(_ spec: inout Spec) {
        spec.setMethod(.post)
        spec.setPath(path)
    }
}

public struct PUT: SpecBuilderParameter {
    let path: String?

    public init(
        _ path: String? = nil
    ) {
        self.path = path
    }

    public func build(_ spec: inout Spec) {
        spec.setMethod(.put)
        spec.setPath(path)
    }
}

public struct PATCH: SpecBuilderParameter {
    let path: String?

    public init(
        _ path: String? = nil
    ) {
        self.path = path
    }

    public func build(_ spec: inout Spec) {
        spec.setMethod(.patch)
        spec.setPath(path)
    }
}

public struct HEAD: SpecBuilderParameter {
    let path: String?

    public init(
        _ path: String? = nil
    ) {
        self.path = path
    }

    public func build(_ spec: inout Spec) {
        spec.setMethod(.head)
        spec.setPath(path)
    }
}

public struct DELETE: SpecBuilderParameter {
    let path: String?

    public init(
        _ path: String? = nil
    ) {
        self.path = path
    }

    public func build(_ spec: inout Spec) {
        spec.setMethod(.delete)
        spec.setPath(path)
    }
}

// MARK: - JSON helpers

public struct JSONBody<T: Encodable>: SpecBuilderParameter {
    let body: HTTPBody

    public init(
        _ value: T,
        encoder: JSONEncoder? = nil
    ) {
        let encoder =
            encoder
            ?? {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                return encoder
            }()
        let data = try! encoder.encode(value)
        self.body = .init(.init(buffer: .init(data: data)))
    }

    public func build(_ spec: inout Spec) {
        spec.setHeader(.contentType, "application/json")
        spec.setBody(body)
    }
}

public struct JSONResponse<T: Decodable>: SpecBuilderParameter {
    let status: HTTPResponse.Status
    let expectation: Expectation

    public init(
        file: StaticString = #file,
        line: UInt = #line,
        status: HTTPResponse.Status = .ok,
        type: T.Type,
        decoder: JSONDecoder? = nil,
        block: @escaping ((T) async throws -> Void)
    ) {

        let decoder =
            decoder
            ?? {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }()
        self.status = status
        self.expectation = .init(
            file: file,
            line: line,
            block: { response, body in
                let buffer = try await body.collect()
                let object = try decoder.decode(T.self, from: buffer)
                try await block(object)
            }
        )
    }

    public func build(_ spec: inout Spec) {
        spec.addExpectation(
            file: expectation.file,
            line: expectation.line,
            status
        )
        spec.addExpectation(
            file: expectation.file,
            line: expectation.line,
            .contentType
        ) { value in
            XCTAssertTrue(value.contains("application/json"))
        }
        spec.addExpectation(
            file: expectation.file,
            line: expectation.line,
            expectation.block
        )
    }
}

// MARK: - JSON error helpers

public struct JSONErrorBadRequest: SpecBuilderParameter {
    public typealias DataType = Components.Schemas.GenericBadRequestError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .badRequest,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorConflict: SpecBuilderParameter {
    public typealias DataType = Components.Schemas.GenericConflictError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .conflict,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorForbidden: SpecBuilderParameter {
    public typealias DataType = Components.Schemas.GenericForbiddenError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .forbidden,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorGone: SpecBuilderParameter {
    public typealias DataType = Components.Schemas.GenericGoneError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .gone,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorMethodNotAllowed: SpecBuilderParameter {
    public typealias DataType = Components.Schemas.GenericMethodNotAllowedError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .methodNotAllowed,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorNotAcceptable: SpecBuilderParameter {
    public typealias DataType = Components.Schemas.GenericNotAcceptableError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .notAcceptable,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)

    }
}

public struct JSONErrorNotFound: SpecBuilderParameter {
    public typealias DataType = Components.Schemas.GenericNotFoundError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .notFound,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorUnauthorized: SpecBuilderParameter {
    public typealias DataType = Components.Schemas.GenericUnauthorizedError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .unauthorized,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorUnprocessableContent: SpecBuilderParameter {
    public typealias DataType = Components.Schemas
        .GenericUnprocessableContentError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .unprocessableContent,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorUnsupportedMediaType: SpecBuilderParameter {
    public typealias DataType = Components.Schemas
        .GenericUnsupportedMediaTypeError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .unsupportedMediaType,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}

public struct JSONErrorInternalServer: SpecBuilderParameter {
    public typealias DataType = Components.Schemas
        .GenericInternalServerErrorError

    let block: ((DataType) async throws -> Void)

    public init(
        block: @escaping ((DataType) async throws -> Void)
    ) {
        self.block = block
    }

    public func build(_ spec: inout Spec) {
        JSONResponse(
            status: .internalServerError,
            type: DataType.self
        ) { value in
            try await block(value)
        }
        .build(&spec)
    }
}
