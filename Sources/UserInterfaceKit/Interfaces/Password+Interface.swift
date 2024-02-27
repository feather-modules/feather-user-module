//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import FeatherKit

public protocol UserPasswordInterface {

    func setPassword(
        token: String,
        _ input: User.Password.Set
    ) async throws

    func resetPassword(
        _ input: User.Password.Reset
    ) async throws

}
