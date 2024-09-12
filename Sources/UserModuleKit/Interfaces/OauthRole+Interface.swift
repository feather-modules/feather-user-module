//
//  File.swift
//
//  Created by gerp83 on 11/09/2024
//

import FeatherModuleKit
import SystemModuleKit

public protocol UserOauthRoleInterface: Sendable {

    func list(
        _ input: User.OauthRole.List.Query
    ) async throws -> User.OauthRole.List

    func reference(
        ids: [ID<User.OauthRole>]
    ) async throws -> [User.OauthRole.Reference]

    func create(
        _ input: User.OauthRole.Create
    ) async throws -> User.OauthRole.Detail

    func require(
        _ id: ID<User.OauthRole>
    ) async throws -> User.OauthRole.Detail

    func update(
        _ id: ID<User.OauthRole>,
        _ input: User.OauthRole.Update
    ) async throws -> User.OauthRole.Detail

    func patch(
        _ id: ID<User.OauthRole>,
        _ input: User.OauthRole.Patch
    ) async throws -> User.OauthRole.Detail

    func bulkDelete(
        ids: [ID<User.OauthRole>]
    ) async throws

    func getPermissionsKeys(
        _ roleKeys: [ID<User.OauthRole>]
    ) async throws -> [ID<System.Permission>]

}
