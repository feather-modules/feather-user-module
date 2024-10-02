//
//  Group+Interface.swift
//
//  Created by gerp83 on 2024. 10. 01.
//

import FeatherModuleKit
import SystemModuleKit

public protocol UserGroupInterface: Sendable {

    func list(
        _ input: User.Group.List.Query
    ) async throws -> User.Group.List

    func listUsers(
        _ id: ID<User.Group>,
        _ input: User.Account.List.Query
    ) async throws -> User.Group.UserList

    func reference(
        ids: [ID<User.Group>]
    ) async throws -> [User.Group.Reference]

    func create(
        _ input: User.Group.Create
    ) async throws -> User.Group.Detail

    func require(
        _ id: ID<User.Group>
    ) async throws -> User.Group.Detail

    func update(
        _ id: ID<User.Group>,
        _ input: User.Group.Update
    ) async throws -> User.Group.Detail

    func bulkDelete(
        ids: [ID<User.Group>]
    ) async throws

}
