//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import CoreSDKInterface

public protocol UserAccountInterface {

    func list(
        _ input: User.Account.List.Query
    ) async throws -> User.Account.List

    func reference(
        ids: [ID<User.Account>]
    ) async throws -> [User.Account.Reference]

    func create(
        _ input: User.Account.Create
    ) async throws -> User.Account.Detail

    func get(
        id: ID<User.Account>
    ) async throws -> User.Account.Detail

    func update(
        id: ID<User.Account>,
        _ input: User.Account.Update
    ) async throws -> User.Account.Detail

    func patch(
        id: ID<User.Account>,
        _ input: User.Account.Patch
    ) async throws -> User.Account.Detail

    func bulkDelete(
        ids: [ID<User.Account>]
    ) async throws

}
