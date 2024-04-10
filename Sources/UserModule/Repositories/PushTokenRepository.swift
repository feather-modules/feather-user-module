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

struct PushTokenRepository: UserPushTokenInterface {
    
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
    ) async throws -> UserModuleKit.User.PushToken.Detail? {
        let queryBuilder = try await getQueryBuilder()
        guard let model = try await queryBuilder.get(id) else {
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

    public func create(
        _ input: User.PushToken.Create
    ) async throws -> User.PushToken.Detail {
        try await input.validate()
        let queryBuilder = try await getQueryBuilder()
        let newModel = User.PushToken.Model(
            accountId: input.accountId.toKey(),
            platform: input.platform.rawValue,
            token: input.token
        )
        try await queryBuilder.insert(newModel)
        return try await getDetail(input.accountId)
    }

    public func update(
        id: ID<User.Account>,
        _ input: User.PushToken.Update
    ) async throws -> User.PushToken.Detail {
        try await input.validate()
        let queryBuilder = try await getQueryBuilder()
        guard let pushToken = try await queryBuilder.get(id)
        else {
            throw User.Error.unknown
        }

        let newModel = User.PushToken.Model(
            accountId: pushToken.accountId,
            platform: pushToken.platform,
            token: input.token
        )
        try await queryBuilder.update(id, newModel)
        return try await getDetail(id)
    }

    public func delete(id: ID<User.Account>) async throws {
        let queryBuilder = try await getQueryBuilder()
        try await queryBuilder.delete(
            filter: .init(
                field: .accountId,
                operator: .in,
                value: [id]
            )
        )
    }

    private func getQueryBuilder() async throws -> User.PushToken.Query {
        let rdb = try await components.relationalDatabase()
        let db = try await rdb.database()
        return .init(db: db)
    }

    private func getDetail(_ id: ID<User.Account>) async throws
        -> User.PushToken.Detail
    {
        let queryBuilder = try await getQueryBuilder()
        guard let model = try await queryBuilder.get(id) else {
            throw User.Error.unknown
        }
        return User.PushToken.Detail(
            accountId: model.accountId.toID(),
            platform: User.PushToken.Platform(rawValue: model.platform)!,
            token: model.token
        )
    }

}
