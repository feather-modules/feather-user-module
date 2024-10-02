//
//  AccountGroupController.swift
//
//  Created by gerp83 on 2024. 10. 01.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Logging
import NanoID
import SQLKit
import SystemModuleKit
import UserModuleDatabaseKit
import UserModuleKit

struct AccountGroupController: UserAccountGroupInterface,
    ControllerCreate,
    ControllerUpdate,
    ControllerDelete
{

    typealias Create = User.AccountGroup.Create
    typealias Detail = User.AccountGroup.Detail
    typealias Query = User.AccountGroup.Query
    typealias Update = User.AccountGroup.Update

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    func require(_ id: ID<User.Account>) async throws
        -> User.AccountGroup.Detail
    {
        let db = try await components.database().connection()
        guard
            let model = try await User.AccountGroup.Query.getFirst(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: User.AccountGroup.Model.self),
                keyName: User.AccountGroup.Model.keyName.rawValue
            )
        }
        return model.toDetail()
    }

}
