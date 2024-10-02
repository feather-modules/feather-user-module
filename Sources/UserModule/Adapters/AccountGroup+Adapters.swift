//
//  AccountGroup+Adapters.swift
//
//  Created by gerp83 on 2024. 10. 01.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import SystemModuleKit
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountGroup.Model: CreateAdapter, UpdateAdapter {

    public init(create: User.AccountGroup.Create) throws {
        self.init(
            accountId: create.accountId.toKey(),
            groupId: create.groupId.toKey()
        )
    }

    public init(update: User.AccountGroup.Update, oldModel: Self) throws {
        self.init(
            accountId: oldModel.accountId,
            groupId: update.groupId.toKey()
        )
    }

}

extension User.AccountGroup.Detail: DetailAdapter {
    public init(model: User.AccountGroup.Model) throws {
        self.init(
            accountId: model.accountId.toID(),
            groupId: model.groupId.toID()
        )
    }
}

extension User.AccountGroup.Model {
    func toDetail() -> User.AccountGroup.Detail {
        .init(accountId: self.accountId.toID(), groupId: self.groupId.toID())
    }

}

extension User.Account.Model {
    func toGroupItem(_ groupId: ID<User.Group>) -> User.Group.UserList.Item {
        .init(
            id: groupId,
            account: self.toReference()
        )
    }
}
