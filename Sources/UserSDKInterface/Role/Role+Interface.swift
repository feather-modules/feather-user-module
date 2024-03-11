//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import CoreSDKInterface

public protocol UserRoleInterface {

    func listRoles(
        _ input: User.Role.List.Query
    ) async throws -> User.Role.List

    func referenceRoles(
        keys: [ID<User.Role>]
    ) async throws -> [User.Role.Reference]

    func createRole(
        _ input: User.Role.Create
    ) async throws -> User.Role.Detail

    func getRole(
        key: ID<User.Role>
    ) async throws -> User.Role.Detail

    func updateRole(
        key: ID<User.Role>,
        _ input: User.Role.Update
    ) async throws -> User.Role.Detail

    func patchRole(
        key: ID<User.Role>,
        _ input: User.Role.Patch
    ) async throws -> User.Role.Detail

    func bulkDeleteRole(
        keys: [ID<User.Role>]
    ) async throws

}
