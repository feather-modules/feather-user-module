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
import UserSDKInterface

extension UserSDK {

    public func createPush(
        _ input: UserPushCreate
    ) async throws -> UserPushDetail {
        fatalError()
    }

    public func updatePush(
        id: ID<User.Push>,
        _ input: UserPushUpdate
    ) async throws -> UserPushDetail {
        fatalError()
    }

    public func deletePush(
        id: ID<User.Push>
    ) async throws {
        fatalError()
    }
}
