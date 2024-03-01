//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import CoreInterfaceKit
import FeatherComponent
import Foundation
import Logging
import UserInterfaceKit

extension UserSDK {

    public func register(
        token: String,
        _ input: User.Account.Create
    ) async throws -> User.Auth.Response {
        .init(
            account: .init(id: .init(""), email: "", roles: []),
            token: .init(value: .init(""), expiration: .init()),
            roles: []
        )
    }
}
