//
//  AccountGroup+Interface.swift
//
//  Created by gerp83 on 2024. 10. 02.
//

import FeatherModuleKit
import SystemModuleKit

public protocol UserAccountGroupInterface: Sendable {

    func create(
        _ input: User.AccountGroup.Create
    ) async throws -> User.AccountGroup.Detail

    func require(
        _ id: ID<User.Account>
    ) async throws -> User.AccountGroup.Detail

    func update(
        _ id: ID<User.Account>,
        _ input: User.AccountGroup.Update
    ) async throws -> User.AccountGroup.Detail

    func bulkDelete(
        ids: [ID<User.Account>]
    ) async throws

}
