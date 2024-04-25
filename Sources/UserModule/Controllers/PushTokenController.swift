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

struct PushTokenController: UserPushTokenInterface,
    ControllerCreate,
    ControllerDelete,
    ControllerUpdate
{

    typealias Detail = User.PushToken.Detail
    typealias Query = User.PushToken.Query
    typealias Update = User.PushToken.Update
    typealias Create = User.PushToken.Create

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

    func get(
        id: ID<User.Account>
    ) async throws -> User.PushToken.Detail? {
        let db = try await components.database().connection()
        guard
            let model = try await User.PushToken.Query.getFirst(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: [id]
                ),
                on: db
            )
        else {
            return nil
        }
        guard let platform = User.PushToken.Platform(rawValue: model.platform)
        else {
            return nil
        }
        return User.PushToken.Detail(
            accountId: model.accountId.toID(),
            platform: platform,
            token: model.token
        )
    }

}
