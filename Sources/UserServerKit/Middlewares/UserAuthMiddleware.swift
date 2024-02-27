//
//  File.swift
//
//
//  Created by Tibor Bodecs on 05/02/2024.
//

import FeatherComponent
//import NIOFoundationCompat
import Foundation
import HTTPTypes
import NIOCore
import OpenAPIRuntime
import UserInterfaceKit
import UserKit
import UserOpenAPIRuntimeKit

public struct UserAuthMiddleware: ServerMiddleware {

    let sdk: UserInterface

    public init(
        sdk: UserInterface
    ) {
        self.sdk = sdk
    }

    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, ServerRequestMetadata)
            async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        let publicEndpoints = [
            "postUserAuth",
            "postUserRegister",
            "setUserPassword",
            "resetUserPassword",
        ]

        guard !publicEndpoints.contains(operationID) else {
            return try await next(request, body, metadata)
        }

        guard let bearerToken = request.headerFields[.authorization] else {
            return try await next(request, body, metadata)
        }
        let prefix = "Bearer "
        guard bearerToken.hasPrefix(prefix) else {
            return try await next(request, body, metadata)
        }
        let token = String(bearerToken.dropFirst(prefix.count))

        let user = try await sdk.auth(token)
        return try await sdk.auth(user) {
            try await next(request, body, metadata)
        }
    }
}
