//
//  File.swift
//
//  Created by gerp83 on 04/09/2024
//

import FeatherModuleKit

public protocol UserAccountInvitationTypeInterface: Sendable {

    func reference(
        ids: [ID<User.AccountInvitationType>]
    ) async throws -> [User.AccountInvitationType.Reference]

    func create(
        _ input: User.AccountInvitationType.Create
    ) async throws -> User.AccountInvitationType.Detail

    func require(
        _ id: ID<User.AccountInvitationType>
    ) async throws -> User.AccountInvitationType.Detail

    func list(
        _ input: User.AccountInvitationType.List.Query
    ) async throws -> User.AccountInvitationType.List

}
