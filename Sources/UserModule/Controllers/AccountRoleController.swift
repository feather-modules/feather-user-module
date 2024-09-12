//
//  File.swift
//
//  Created by gerp83 on 11/09/2024
//
    

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Logging
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

struct AccountRoleController: UserAccountRoleInterface {

    typealias Query = User.AccountRole.Query
    
    let components: ComponentRegistry
    let user: UserModuleInterface
    
    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }
    
    func create(_ input: User.AccountRole.Create) async throws -> User.AccountRole.Detail {
        let db = try await components.database().connection()
        let model = User.AccountRole.Model(
            accountId: input.accountId.toKey(),
            roleKey: input.roleKey.toKey()
        )
        try await User.AccountRole.Query.insert(model, on: db)
        return .init(accountId: model.accountId.toID(), roleKey: model.roleKey.toID())
    }
    
    func require(_ id: ID<User.Account>) async throws -> User.AccountRole.Detail {
        let db = try await components.database().connection()
        guard
            let model = try await User.AccountRole.Query.getFirst(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: User.AccountInvitation.Model.self),
                keyName: User.AccountRole.Model.keyName.rawValue
            )
        }
        return .init(accountId: model.accountId.toID(), roleKey: model.roleKey.toID())
    }
    
}
