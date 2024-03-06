//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import CoreSDKInterface

public protocol UserPushInterface {

    func createPush(
        _ input: UserPushCreate
    ) async throws -> UserPushDetail

    func updatePush(
        id: ID<User.Push>,
        _ input: UserPushUpdate
    ) async throws -> UserPushDetail

    func deletePush(
        id: ID<User.Push>
    ) async throws
}
