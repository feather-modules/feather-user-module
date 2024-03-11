//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import CoreSDKInterface

public protocol UserAccountInterface {

    func listAccounts(
        _ input: User.Account.List.Query
    ) async throws -> User.Account.List

    func referenceAccounts(
        keys: [ID<User.Account>]
    ) async throws -> [User.Account.Reference]

    func createAccount(
        _ input: User.Account.Create
    ) async throws -> User.Account.Detail

    func getAccount(
        key: ID<User.Account>
    ) async throws -> User.Account.Detail

    func updateAccount(
        key: ID<User.Account>,
        _ input: User.Account.Update
    ) async throws -> User.Account.Detail

    func patchAccount(
        key: ID<User.Account>,
        _ input: User.Account.Patch
    ) async throws -> User.Account.Detail

    func bulkDeleteAccount(
        keys: [ID<User.Account>]
    ) async throws

}
