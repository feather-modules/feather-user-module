//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import FeatherModuleKit
import SystemModuleKit

public protocol UserAccountInterface: Sendable {

    func list(
        _ input: User.Account.List.Query
    ) async throws -> User.Account.List

    func listWithoutRole(
        _ ownAccountId: ID<User.Account>,
        _ roleKey: ID<User.Role>,
        _ input: User.Account.List.Query
    ) async throws -> User.Account.List

    func reference(
        ids: [ID<User.Account>]
    ) async throws -> [User.Account.Reference]

    func create(
        _ input: User.Account.Create
    ) async throws -> User.Account.Detail

    func require(
        _ id: ID<User.Account>
    ) async throws -> User.Account.Detail

    func update(
        _ id: ID<User.Account>,
        _ input: User.Account.Update
    ) async throws -> User.Account.Detail

    func patch(
        _ id: ID<User.Account>,
        _ input: User.Account.Patch
    ) async throws -> User.Account.Detail

    func bulkDelete(
        ids: [ID<User.Account>]
    ) async throws

    func getRolesAndPermissonsForId(
        _ id: ID<User.Account>
    ) async throws -> ([User.Role.Reference], [ID<System.Permission>], [User.Group.Reference])
}
