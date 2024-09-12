//
//  File.swift
//
//  Created by gerp83 on 11/09/2024
//
    
import FeatherModuleKit

public protocol UserAccountRoleInterface: Sendable {

    func create(
        _ input: User.AccountRole.Create
    ) async throws -> User.AccountRole.Detail

    func require(
        _ id: ID<User.Account>
    ) async throws -> User.AccountRole.Detail

}
