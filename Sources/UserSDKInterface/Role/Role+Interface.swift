//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import CoreSDKInterface

public protocol UserRoleInterface {

    func listRoles(
        _ input: any UserRoleListQuery
    ) async throws -> any UserRoleList

    func referenceRoles(
        keys: [ID<User.Role>]
    ) async throws -> [UserRoleReference]

    func createRole(
        _ input: UserRoleCreate
    ) async throws -> UserRoleDetail

    func getRole(
        key: ID<User.Role>
    ) async throws -> UserRoleDetail

    func updateRole(
        key: ID<User.Role>,
        _ input: UserRoleUpdate
    ) async throws -> UserRoleDetail

    func patchRole(
        key: ID<User.Role>,
        _ input: UserRolePatch
    ) async throws -> UserRoleDetail

    func bulkDeleteRole(
        keys: [ID<User.Role>]
    ) async throws

}
