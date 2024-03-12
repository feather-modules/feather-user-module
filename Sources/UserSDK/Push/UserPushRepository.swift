//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreSDKInterface
import FeatherComponent
import Foundation
import Logging
import SystemSDKInterface
import UserSDKInterface

struct UserPushRepository: UserPushInterface {

    let components: ComponentRegistry
    let system: SystemInterface
    let role: UserRoleInterface
    let account: UserAccountInterface
    let logger: Logger

    public init(
        components: ComponentRegistry,
        system: SystemInterface,
        role: UserRoleInterface,
        account: UserAccountInterface,
        logger: Logger = .init(label: "user-push-repository")
    ) {
        self.components = components
        self.system = system
        self.role = role
        self.account = account
        self.logger = logger
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
