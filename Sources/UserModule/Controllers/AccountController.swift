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
import UserModuleDatabaseKit
import UserModuleKit

struct AccountController: UserAccountInterface,
    ControllerDelete,
    ControllerList,
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
            password: input.password
        )
        try await input.validate(on: db)
        try await User.Account.Query.insert(model, on: db)
        try await updateAccountRoles(
            input.roleKeys,
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
            password: input.password ?? oldModel.password
        )

        try await User.Account.Query.update(id.toKey(), newModel, on: db)
        try await updateAccountRoles(
            input.roleKeys,
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
            password: input.password ?? oldModel.password
        )
        try await User.Account.Query.update(id.toKey(), newModel, on: db)

        if let roleKeys = input.roleKeys {
            try await updateAccountRoles(roleKeys, id, db)
        }
        return try await getAccountBy(id: id, db)
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

        let roleKeys = try await User.AccountRole.Query
            .listAll(
                filter: .init(
                    column: .accountId,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
            .map { $0.roleKey }
            .map { $0.toID() }

        let roles = try await user.role.reference(ids: roleKeys)

        return User.Account.Detail(
            id: model.id.toID(),
            email: model.email,
            roles: roles
        )
    }
}
