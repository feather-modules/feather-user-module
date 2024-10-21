//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
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

struct AccountController: UserAccountInterface,
    ControllerList,
    ControllerDelete,
    ControllerReference
{

    typealias Query = User.Account.Query
    typealias Reference = User.Account.Reference
    typealias List = User.Account.List

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
            .email
        ]

    // MARK: -

    func create(
        _ input: User.Account.Create
    ) async throws -> User.Account.Detail {
        let db = try await components.database().connection()
        let input = try input.sanitized()
        let model = User.Account.Model(
            id: NanoID.generateKey(),
            email: input.email,
            password: input.password,
            firstName: input.firstName,
            lastName: input.lastName,
            imageKey: input.imageKey
        )
        try await input.validate(on: db)
        try await User.Account.Query.insert(model, on: db)
        try await updateAccountRoles(
            input.roleKeys,
            model.id.toID(),
            db
        )
        try await updateAccountGroups(
            input.groupIds,
            model.id.toID(),
            db
        )
        return try await getAccountBy(id: model.id.toID(), db)
    }

    func require(
        _ id: FeatherModuleKit.ID<User.Account>
    ) async throws -> User.Account.Detail {
        let db = try await components.database().connection()
        return try await getAccountBy(id: id, db)
    }

    func update(
        _ id: ID<User.Account>,
        _ input: User.Account.Update
    ) async throws -> User.Account.Detail {
        let db = try await components.database().connection()
        let oldModel = try await User.Account.Query.require(id.toKey(), on: db)

        let input = try input.sanitized()
        try await input.validate(oldModel.email, on: db)
        let newModel = User.Account.Model(
            id: oldModel.id,
            email: input.email,
            password: input.password ?? oldModel.password,
            firstName: input.firstName,
            lastName: input.lastName,
            imageKey: input.imageKey
        )

        try await User.Account.Query.update(id.toKey(), newModel, on: db)
        try await updateAccountRoles(
            input.roleKeys,
            id,
            db
        )
        try await updateAccountGroups(
            input.groupIds,
            id,
            db
        )
        return try await getAccountBy(id: id, db)
    }

    func patch(
        _ id: ID<User.Account>,
        _ input: User.Account.Patch
    ) async throws -> User.Account.Detail {
        let db = try await components.database().connection()
        let oldModel = try await User.Account.Query.require(id.toKey(), on: db)

        let input = try input.sanitized()
        try await input.validate(oldModel.email, on: db)
        let newModel = User.Account.Model(
            id: oldModel.id,
            email: input.email ?? oldModel.email,
            password: input.password ?? oldModel.password,
            firstName: input.firstName ?? oldModel.firstName,
            lastName: input.lastName ?? oldModel.lastName,
            imageKey: input.imageKey ?? oldModel.imageKey
        )
        try await User.Account.Query.update(id.toKey(), newModel, on: db)

        if let roleKeys = input.roleKeys {
            try await updateAccountRoles(roleKeys, id, db)
        }
        try await updateAccountGroups(
            input.groupIds,
            id,
            db
        )
        return try await getAccountBy(id: id, db)
    }

    func getRolesAndPermissonsForId(
        _ id: ID<User.Account>
    ) async throws -> (
        [User.Role.Reference], [ID<System.Permission>], [User.Group.Reference]
    ) {
        let db = try await components.database().connection()
        return try await id.getArrayDataForId(user, db)
    }

    func listWithoutRole(
        _ ownAccountId: ID<User.Account>,
        _ roleKey: ID<User.Role>,
        _ input: User.Account.List.Query
    ) async throws -> User.Account.List {
        let db = try await components.database().connection()
        let accountRoles = try await User.AccountRole.Query.listAll(
            filter: .init(
                column: .roleKey,
                operator: .equal,
                value: roleKey
            ),
            on: db
        )
        // remove duplicates and remove own id
        let accountIds =
            accountRoles
            .map { $0.accountId.rawValue }
            .removingDuplicates()
            .filter { $0 != ownAccountId.rawValue }

        let filter: DatabaseFilter<User.Account.Model.ColumnNames> =
            DatabaseFilter(
                column: .id,
                operator: .notIn,
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
        return try .init(items: result.items, count: result.total)
    }

}

extension AccountController {

    fileprivate func updateAccountRoles(
        _ roleKeys: [ID<User.Role>],
        _ id: ID<User.Account>,
        _ db: Database
    ) async throws {
        guard
            let _ = try await User.Account.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .is,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: User.Account.Model.self),
                keyName: User.Account.Model.keyName.rawValue
            )
        }

        let roles = try await user.role.reference(ids: roleKeys)
        try await User.AccountRole.Query.delete(
            filter: .init(
                column: .accountId,
                operator: .equal,
                value: id
            ),
            on: db
        )
        try await User.AccountRole.Query.insert(
            roles.map {
                User.AccountRole.Model(
                    accountId: id.toKey(),
                    roleKey: $0.key.toKey()
                )
            },
            on: db
        )
    }

    fileprivate func updateAccountGroups(
        _ groupIds: [ID<User.Group>]?,
        _ id: ID<User.Account>,
        _ db: Database
    ) async throws {
        if let groupIds {
            guard
                let _ = try await User.Account.Query.getFirst(
                    filter: .init(
                        column: .id,
                        operator: .is,
                        value: id
                    ),
                    on: db
                )
            else {
                throw ModuleError.objectNotFound(
                    model: String(reflecting: User.Account.Model.self),
                    keyName: User.Account.Model.keyName.rawValue
                )
            }

            let groups = try await user.group.reference(ids: groupIds)
            try await User.AccountGroup.Query.delete(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
            try await User.AccountGroup.Query.insert(
                groups.map {
                    User.AccountGroup.Model(
                        accountId: id.toKey(),
                        groupId: $0.id.toKey()
                    )
                },
                on: db
            )
        }
    }

    fileprivate func getAccountBy(
        id: ID<User.Account>,
        _ db: Database
    ) async throws -> User.Account.Detail {
        guard
            let model = try await User.Account.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .is,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: User.Account.Model.self),
                keyName: User.Account.Model.keyName.rawValue
            )
        }
        let data = try await id.getArrayDataForId(user, db)
        return User.Account.Detail(
            id: model.id.toID(),
            email: model.email,
            firstName: model.firstName,
            lastName: model.lastName,
            imageKey: model.imageKey,
            roles: data.0,
            permissions: data.1,
            groups: data.2
        )

    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict: [Element: Bool] = [:]
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
