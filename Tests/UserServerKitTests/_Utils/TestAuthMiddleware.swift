//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

import CoreInterfaceKit
import HTTPTypes
import Logging
import OpenAPIRuntime

struct TestAuthMiddleware: ServerMiddleware {
    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, ServerRequestMetadata)
            async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        try await ACL.authenticate(TestUser.root()) {
            try await next(request, body, metadata)
        }
    }
}
