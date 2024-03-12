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

struct UserRegisterRepository: UserRegisterInterface {

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
        logger: Logger = .init(label: "user-register-repository")
    ) {
        self.components = components
        self.system = system
        self.role = role
        self.account = account
        self.logger = logger
    }

    public func register(
        token: String,
        _ input: User.Account.Create
    ) async throws -> User.Auth.Response {
        fatalError()
    }
}
