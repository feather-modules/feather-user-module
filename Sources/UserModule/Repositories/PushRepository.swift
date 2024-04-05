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
    
    private func getQueryBuilder() async throws -> User.PushToken.Query {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)
    }

    // MARK: -

    public func create(
        _ input: User.PushToken.Create
    ) async throws -> User.PushToken.Detail {
        // TODO: implement
        fatalError()
    }

    public func update(
        id: ID<User.Push>,
        _ input: User.PushToken.Update
    ) async throws -> User.PushToken.Detail {
        // TODO: implement
        fatalError()
    }
    
    public func delete(id: FeatherModuleKit.ID<UserModuleKit.User.Account>) async throws {
        // TODO: implement
        fatalError()
    }
    
}
