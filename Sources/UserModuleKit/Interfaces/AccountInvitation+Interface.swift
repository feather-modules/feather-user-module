//
//  File.swift
//
//
//  Created by Lengyel Gábor on 24/04/2024.
//

import FeatherModuleKit

public protocol UserAccountInvitationInterface: Sendable {

    func create(
        _ input: User.AccountInvitation.Create
    ) async throws -> User.AccountInvitation.Detail

    func list(
        _ input: User.AccountInvitation.List.Query
    ) async throws -> User.AccountInvitation.List

    func require(
        _ id: ID<User.AccountInvitation>
    ) async throws -> User.AccountInvitation.Detail

    func bulkDelete(
        ids: [ID<User.AccountInvitation>]
    ) async throws

}
