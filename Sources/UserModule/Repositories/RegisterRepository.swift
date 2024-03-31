//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherModuleKit
import Foundation
import Logging
import SystemModuleKit
import UserModuleKit

struct RegisterRepository: UserRegisterInterface {

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    public func register(
        token: String,
        _ input: User.Account.Create
    ) async throws -> User.Auth.Response {
        fatalError()
    }
}
