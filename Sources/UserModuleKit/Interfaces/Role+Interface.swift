//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import FeatherModuleKit

public protocol UserRoleInterface: Sendable {

    func list(
        _ input: User.Role.List.Query
    ) async throws -> User.Role.List

    func reference(
        keys: [ID<User.Role>]
    ) async throws -> [User.Role.Reference]

    func create(
        _ input: User.Role.Create
    ) async throws -> User.Role.Detail

    func get(
        key: ID<User.Role>
    ) async throws -> User.Role.Detail

    func update(
        key: ID<User.Role>,
        _ input: User.Role.Update
    ) async throws -> User.Role.Detail

    func patch(
        key: ID<User.Role>,
        _ input: User.Role.Patch
    ) async throws -> User.Role.Detail

    func bulkDelete(
        keys: [ID<User.Role>]
    ) async throws

}
