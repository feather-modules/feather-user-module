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

    public func setUserPassword(_ input: Operations.setUserPassword.Input)
        async throws -> Operations.setUserPassword.Output
    {
        switch input.body {
        case .json(let content):
            guard let token = input.query.token, !token.isEmpty else {
                return .noContent(.init())  // TODO: bad request param
            }
            try await sdk.setPassword(token: token, content.toSDK())
            return .noContent(.init())
        }
    }

    public func resetUserPassword(_ input: Operations.resetUserPassword.Input)
        async throws -> Operations.resetUserPassword.Output
    {
        switch input.body {
        case .json(let content):
            try await sdk.resetPassword(content.toSDK())
            return .noContent(.init())
        }
    }

}
