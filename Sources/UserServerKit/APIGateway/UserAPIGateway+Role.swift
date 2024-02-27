//
//  EducationServerAPI+UserRole.swift
//
//
//  Created by mzperx on 16/01/2024.
//

import FeatherComponent
import Logging
import OpenAPIRuntime
import UserInterfaceKit
import UserKit
import UserOpenAPIRuntimeKit

extension UserAPIGateway {

    public func listUserRole(_ input: Operations.listUserRole.Input)
        async throws -> Operations.listUserRole.Output
    {
        let result = try await sdk.listRoles(input.query.toSDK())
        return .ok(.init(body: .json(result.toAPI())))
    }

    public func createUserRole(_ input: Operations.createUserRole.Input)
        async throws -> Operations.createUserRole.Output
    {
        switch input.body {
        case .json(let content):
            let result = try await sdk.createRole(content.toSDK())
            return .ok(.init(body: .json(result.toAPI())))
        }
    }

    public func bulkDeleteUserRole(
        _ input: Operations.bulkDeleteUserRole.Input
    ) async throws -> Operations.bulkDeleteUserRole.Output {
        switch input.body {
        case .json(let content):
            try await sdk.bulkDeleteRole(keys: content.toSDK())
            return .noContent(.init())
        }
    }

    public func detailUserRole(_ input: Operations.detailUserRole.Input)
        async throws -> Operations.detailUserRole.Output
    {
        let result = try await sdk.getRole(key: .init(input.path.roleKey))
        return .ok(.init(body: .json(result.toAPI())))
    }

    public func patchUserRole(_ input: Operations.patchUserRole.Input)
        async throws -> Operations.patchUserRole.Output
    {
        switch input.body {
        case .json(let content):
            let result = try await sdk.patchRole(
                key: .init(input.path.roleKey),
                content.toSDK()
            )
            return .ok(.init(body: .json(result.toAPI())))
        }
    }

    public func updateUserRole(_ input: Operations.updateUserRole.Input)
        async throws -> Operations.updateUserRole.Output
    {
        switch input.body {
        case .json(let content):
            let result = try await sdk.updateRole(
                key: .init(input.path.roleKey),
                content.toSDK()
            )
            return .ok(.init(body: .json(result.toAPI())))
        }
    }
}
