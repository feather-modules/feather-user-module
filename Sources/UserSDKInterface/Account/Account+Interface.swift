//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import CoreSDKInterface

public protocol UserAccountInterface {

    func listAccounts(
        _ input: any UserAccountListQuery
    ) async throws -> any UserAccountList

    func referenceAccounts(
        keys: [ID<User.Account>]
    ) async throws -> [UserAccountReference]

    func createAccount(
        _ input: UserAccountCreate
    ) async throws -> UserAccountDetail

    func getAccount(
        key: ID<User.Account>
    ) async throws -> UserAccountDetail

    func updateAccount(
        key: ID<User.Account>,
        _ input: UserAccountUpdate
    ) async throws -> UserAccountDetail

    func patchAccount(
        key: ID<User.Account>,
        _ input: UserAccountPatch
    ) async throws -> UserAccountDetail

    func bulkDeleteAccount(
        keys: [ID<User.Account>]
    ) async throws

}
