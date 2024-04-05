//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import FeatherModuleKit

public protocol UserPushInterface {

    func create(
        _ input: User.PushToken.Create
    ) async throws -> User.PushToken.Detail

    func update(
        id: ID<User.Push>,
        _ input: User.PushToken.Update
    ) async throws -> User.PushToken.Detail

    func delete(
        id: ID<User.Account>
    ) async throws
}
