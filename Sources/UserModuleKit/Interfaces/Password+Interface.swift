//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import CoreModuleKit

public protocol UserPasswordInterface {

    func set(
        token: String,
        _ input: User.Password.Set
    ) async throws

    func reset(
        _ input: User.Password.Reset
    ) async throws

}
