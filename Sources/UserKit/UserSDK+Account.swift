//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherKit
import FeatherValidation
import Logging
import UserInterfaceKit

extension UserSDK {

    public func listAccounts(
        _ input: List.Query<
            User.Account.List.Sort
        >
    ) async throws
        -> List.Result<
            User.Account.List.Item,
            User.Account.List.Sort
        >
    {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(User.Account.ACL.list.rawValue)

        do {
            let db = try await components.relationalDatabase().connection()
            let queryBuilder = User.Account.Query(db: db)

            return
                try await queryBuilder.all(
                    query: .init(
                        input: input,
                        queryBuilderType: User.Account.Query.self
                    )
                )
                .toResult(input: input) { $0.toListItem() }
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func createAccount(
        _ input: User.Account.Create
    ) async throws -> User.Account.Detail {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(
            User.Account.ACL.create.rawValue
        )

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Account.Query(db: db)

            // TODO: proper validation
            //            try await input.validate()

            let model = User.Account.Model(try input.sanitized())
            try await qb.insert(model)
            return model.toDetail()
        }
        catch let error as ValidatorError {
            throw UserSDKError.validation(error.failures)
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func getAccount(
        id: ID<User.Account>
    ) async throws -> User.Account.Detail {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(User.Account.ACL.get.rawValue)

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Account.Query(db: db)
            guard let model = try await qb.firstById(value: id.rawValue) else {
                throw UserSDKError.unknown
            }
            return model.toDetail()
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func updateAccount(
        id: ID<User.Account>,
        _ input: User.Account.Update
    ) async throws -> User.Account.Detail {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(
            User.Account.ACL.update.rawValue
        )

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Account.Query(db: db)

            guard let model = try await qb.firstById(value: id.rawValue) else {
                throw UserSDKError.unknown
            }
            //TODO: validate input
            let newModel = model.updated(try input.sanitized())
            try await qb.update(id.rawValue, newModel)
            return newModel.toDetail()
        }
        catch let error as ValidatorError {
            throw UserSDKError.validation(error.failures)
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func patchAccount(
        id: ID<User.Account>,
        _ input: User.Account.Patch
    ) async throws -> User.Account.Detail {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(
            User.Account.ACL.update.rawValue
        )

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Account.Query(db: db)

            guard let model = try await qb.firstById(value: id.rawValue) else {
                throw UserSDKError.unknown
            }
            //TODO: validate input
            let newModel = model.patched(try input.sanitized())
            try await qb.update(id.rawValue, newModel)
            return newModel.toDetail()
        }
        catch let error as ValidatorError {
            throw UserSDKError.validation(error.failures)
        }
        catch {
            throw UserSDKError.database(error)
        }
    }

    public func bulkDeleteAccount(
        ids: [ID<User.Account>]
    ) async throws {
        let user = try await ACL.require(ACL.AuthenticatedUser.self)
        try await user.requirePermission(
            User.Account.ACL.delete.rawValue
        )

        do {
            let db = try await components.relationalDatabase().connection()
            let qb = User.Account.Query(db: db)
            try await qb.delete(ids.map { $0.rawValue })
        }
        catch {
            throw UserSDKError.database(error)
        }
    }
}
