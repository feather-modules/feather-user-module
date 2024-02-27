//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import FeatherKit

public protocol UserPushInterface {

    func createPush(
        _ input: User.Push.Create
    ) async throws -> User.Push.Detail

    func updatePush(
        id: ID<User.Push>,
        _ input: User.Push.Update
    ) async throws -> User.Push.Detail

    func deletePush(
        id: ID<User.Push>
    ) async throws
}
