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
        ids: [ID<User.Role>]
    ) async throws -> [User.Role.Reference]

    func create(
        _ input: User.Role.Create
    ) async throws -> User.Role.Detail

    func get(
        _ id: ID<User.Role>
    ) async throws -> User.Role.Detail

    func update(
        _ id: ID<User.Role>,
        _ input: User.Role.Update
    ) async throws -> User.Role.Detail

    func patch(
        _ id: ID<User.Role>,
        _ input: User.Role.Patch
    ) async throws -> User.Role.Detail

    func bulkDelete(
        ids: [ID<User.Role>]
    ) async throws

}
