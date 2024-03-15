//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreModuleInterface
import FeatherComponent
import Foundation
import Logging
import SystemModuleInterface
import UserModuleInterface

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
