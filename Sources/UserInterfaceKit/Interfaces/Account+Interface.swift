//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import FeatherKit

public protocol UserAccountInterface {

    func listAccounts(
        _ input: List.Query<
            User.Account.List.Sort
        >
    ) async throws
        -> List.Result<
            User.Account.List.Item,
            User.Account.List.Sort
        >

    func createAccount(
        _ input: User.Account.Create
    ) async throws -> User.Account.Detail

    func getAccount(
        id: ID<User.Account>
    ) async throws -> User.Account.Detail

    func updateAccount(
        id: ID<User.Account>,
        _ input: User.Account.Update
    ) async throws -> User.Account.Detail

    func patchAccount(
        id: ID<User.Account>,
        _ input: User.Account.Patch
    ) async throws -> User.Account.Detail

    func bulkDeleteAccount(
        ids: [ID<User.Account>]
    ) async throws
}
