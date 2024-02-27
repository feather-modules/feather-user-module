//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherKit
import Foundation
import Logging
import UserInterfaceKit

extension UserSDK {
    public func createPush(
        _ input: User.Push.Create
    ) async throws -> User.Push.Detail {
        .init(platform: .android, token: "")
    }

    public func updatePush(
        id: ID<User.Push>,
        _ input: User.Push.Update
    ) async throws -> User.Push.Detail {
        .init(platform: .android, token: "")
    }

    public func deletePush(
        id: ID<User.Push>
    ) async throws {

    }
}
