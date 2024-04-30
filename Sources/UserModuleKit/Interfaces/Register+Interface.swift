//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import FeatherModuleKit

public protocol UserRegisterInterface: Sendable {

    func register(
        invitationToken: String,
        _ input: User.Account.Create
    ) async throws -> User.Auth.Response

}
