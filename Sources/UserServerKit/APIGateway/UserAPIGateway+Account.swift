//
//  EducationServerAPI+UserAccount.swift
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

    public func listUserAccount(_ input: Operations.listUserAccount.Input)
        async throws -> Operations.listUserAccount.Output
    {
        let result = try await sdk.listAccounts(input.query.toSDK())
        return .ok(.init(body: .json(result.toAPI())))
    }

    public func createUserAccount(_ input: Operations.createUserAccount.Input)
        async throws -> Operations.createUserAccount.Output
    {
        switch input.body {
        case .json(let content):
            let result = try await sdk.createAccount(content.toSDK())
            return .ok(.init(body: .json(result.toAPI())))
        }
    }

    public func bulkDeleteUserAccount(
        _ input: Operations.bulkDeleteUserAccount.Input
    ) async throws -> Operations.bulkDeleteUserAccount.Output {
        switch input.body {
        case .json(let content):
            try await sdk.bulkDeleteRole(keys: content.toSDK())
            return .noContent(.init())
        }
    }

    public func detailUserAccount(_ input: Operations.detailUserAccount.Input)
        async throws -> Operations.detailUserAccount.Output
    {
        let result = try await sdk.getAccount(
            id: .init(input.path.accountId)
        )
        return .ok(.init(body: .json(result.toAPI())))
    }

    public func patchUserAccount(_ input: Operations.patchUserAccount.Input)
        async throws -> Operations.patchUserAccount.Output
    {
        switch input.body {
        case .json(let content):
            let result = try await sdk.patchAccount(
                id: .init(input.path.accountId),
                content.toSDK()
            )
            return .ok(.init(body: .json(result.toAPI())))
        }
    }

    public func updateUserAccount(_ input: Operations.updateUserAccount.Input)
        async throws -> Operations.updateUserAccount.Output
    {
        switch input.body {
        case .json(let content):
            let result = try await sdk.updateAccount(
                id: .init(input.path.accountId),
                content.toSDK()
            )
            return .ok(.init(body: .json(result.toAPI())))
        }
    }
}
