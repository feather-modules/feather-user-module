//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreModuleKit
import FeatherComponent
import Foundation
import Logging
import SystemModuleKit
import UserModuleKit

struct PushRepository: UserPushInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    // MARK: -

    public func create(
        _ input: User.Push.Create
    ) async throws -> User.Push.Detail {
        fatalError()
    }

    public func update(
        id: ID<User.Push>,
        _ input: User.Push.Update
    ) async throws -> User.Push.Detail {
        fatalError()
    }

    public func delete(
        id: ID<User.Push>
    ) async throws {

    }
}
