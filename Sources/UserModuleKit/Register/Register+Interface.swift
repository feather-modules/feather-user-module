//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import CoreModuleKit

public protocol UserRegisterInterface {

    func register(
        token: String,
        _ input: User.Account.Create
    ) async throws -> User.Auth.Response

}
