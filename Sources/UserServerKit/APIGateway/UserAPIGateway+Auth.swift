//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import FeatherComponent
import Logging
import OpenAPIRuntime
import UserInterfaceKit
import UserKit
import UserOpenAPIRuntimeKit

extension UserAPIGateway {

    public func postUserAuth(
        _ input: Operations.postUserAuth.Input
    ) async throws -> Operations.postUserAuth.Output {
        switch input.body {
        case .json(let request):
            let result = try await sdk.postAuth(request.toSDK())
            return .ok(.init(body: .json(result.toAPI())))
        }
    }

    public func deleteUserAuth(
        _ input: Operations.deleteUserAuth.Input
    ) async throws -> Operations.deleteUserAuth.Output {
        try await sdk.deleteAuth()
        return .noContent(.init())
    }
}
