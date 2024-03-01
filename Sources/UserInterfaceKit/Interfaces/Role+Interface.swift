//
//  EducationServerAPI+UserRole.swift
//
//
//  Created by mzperx on 16/01/2024.
//

import CoreInterfaceKit

public protocol UserRoleInterface {

    func listRoles(
        _ input: List.Query<
            User.Role.List.Sort
        >
    ) async throws
        -> List.Result<
            User.Role.List.Item,
            User.Role.List.Sort
        >

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
