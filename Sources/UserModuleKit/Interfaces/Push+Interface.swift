//
//  File.swift
//
//
//  Created by Tibor Bodecs on 02/02/2024.
//

import FeatherModuleKit

public protocol UserPushInterface: Sendable {
    
    func create(
        _ input: User.Push.Create
    ) async throws -> User.Push.Detail

    func get(
        id: ID<User.Push>
    ) async throws -> User.Push.Detail?

    func list(
        _ input: User.Push.List.Query
    ) async throws -> User.Push.List

}
