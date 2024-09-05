//
//  File.swift
//
//
//  Created by gerp83 on 23/08/2024
//

import FeatherModuleKit

public protocol UserOauthClientInterface: Sendable {

    func list(
        _ input: User.OauthClient.List.Query
    ) async throws -> User.OauthClient.List

    func reference(
        ids: [ID<User.OauthClient>]
    ) async throws -> [User.OauthClient.Reference]

    func create(
        _ input: User.OauthClient.Create
    ) async throws -> User.OauthClient.Detail

    func require(
        _ id: ID<User.OauthClient>
    ) async throws -> User.OauthClient.Detail

    func update(
        _ id: ID<User.OauthClient>,
        _ input: User.OauthClient.Update
    ) async throws -> User.OauthClient.Detail

    func patch(
        _ id: ID<User.OauthClient>,
        _ input: User.OauthClient.Patch
    ) async throws -> User.OauthClient.Detail

    func bulkDelete(
        ids: [ID<User.OauthClient>]
    ) async throws
}
