//
//  GroupController.swift
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

struct GroupController: UserGroupInterface,
    ControllerList,
    ControllerDelete,
    ControllerReference
{
    
    typealias Query = User.Group.Query
    typealias Reference = User.Group.Reference
    typealias List = User.Group.List
    typealias Detail = User.Group.Detail

    let components: ComponentRegistry
    let user: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserModuleInterface
    ) {
        self.components = components
        self.user = user
    }

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .name
        ]

    func create(_ input: User.Group.Create) async throws -> User.Group.Detail {
        let db = try await components.database().connection()
        let model = User.Group.Model(
            id: NanoID.generateKey(),
            name: input.name
        )
        try await input.validate(on: db)
        try await User.Group.Query.insert(model, on: db)
        return model.toDetail()
    }

    func require(_ id: ID<User.Group>) async throws -> User.Group.Detail {
        let db = try await components.database().connection()
        guard
            let model = try await User.Group.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: User.Group.Model.self),
                keyName: User.Group.Model.keyName.rawValue
            )
        }
        return model.toDetail()
    }
    
    func update(_ id: ID<User.Group>, _ input: User.Group.Update) async throws -> User.Group.Detail {
        let db = try await components.database().connection()
        let oldModel = try await User.Group.Query.require(id.toKey(), on: db)
        try await input.validate(oldModel.name, on: db)
        
        let newModel = User.Group.Model(
            id: oldModel.id,
            name: input.name
        )
        try await User.Group.Query.update(id.toKey(), newModel, on: db)
        return newModel.toDetail()
    }

    func listUsers(
        _ id: ID<User.Group>,
        _ input: User.Account.List.Query
    ) async throws -> User.Group.UserList {
        let db = try await components.database().connection()
        guard
            let model = try await User.Group.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: User.Group.Model.self),
                keyName: User.Group.Model.keyName.rawValue
            )
        }
        let groupAccounts = try await User.AccountGroup.Query.listAll(
            filter: .init(
                column: .groupId,
                operator: .equal,
                value: model.id
            ),
            on: db
        )
        
        let accountIds = groupAccounts.map { $0.accountId.rawValue }
        let filter: DatabaseFilter<User.Account.Model.ColumnNames> =
            DatabaseFilter(
                column: .id,
                operator: .in,
                value: accountIds
            )
        let filterGroups = DatabaseGroupFilter<User.Account.Model.ColumnNames>(
            columns: [filter]
        )
        let result = try await User.Account.Query.list(
            .init(
                page: .init(
                    size: input.page.size,
                    index: input.page.index
                ),
                orders: [
                    .init(
                        column: .init(listQuerySortKeys: input.sort.by),
                        direction: input.sort.order.queryDirection
                    )
                ],
                filter: .init(
                    relation: .and,
                    groups: [filterGroups]
                )
            ),
            on: db
        )
        
        let groupItems = result.items.map { $0.toGroupItem(model.id.toID()) }
        return .init(items: groupItems, count: result.total)
    }

}
