//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import CoreModuleInterface

public protocol UserPushInterface {

    func create(
        _ input: User.Push.Create
    ) async throws -> User.Push.Detail

    func update(
        id: ID<User.Push>,
        _ input: User.Push.Update
    ) async throws -> User.Push.Detail

    func delete(
        id: ID<User.Push>
    ) async throws
}
