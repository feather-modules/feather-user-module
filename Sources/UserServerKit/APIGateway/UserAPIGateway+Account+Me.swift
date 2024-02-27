//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import FeatherComponent
import Logging
import OpenAPIRuntime
import UserInterfaceKit
import UserKit
import UserOpenAPIRuntimeKit

extension UserAPIGateway {

    public func meUserAccount(_ input: Operations.meUserAccount.Input)
        async throws -> Operations.meUserAccount.Output
    {
        let result = try await sdk.getMyAccount()
        return .ok(.init(body: .json(result.toAPI())))
    }
}
