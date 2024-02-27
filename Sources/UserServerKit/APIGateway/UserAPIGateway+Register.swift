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

    public func postUserRegister(
        _ input: Operations.postUserRegister.Input
    ) async throws -> Operations.postUserRegister.Output {
        switch input.body {
        case .json(let content):
            guard let token = input.query.token, !token.isEmpty else {
                fatalError("bad request")  // TODO: bad request
            }
            let result = try await sdk.register(
                token: token,
                content.toSDK()
            )
            return .ok(.init(body: .json(result.toAPI())))
        }
    }

}
