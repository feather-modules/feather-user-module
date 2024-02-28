//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import FeatherKit
import UserInterfaceKit

extension User.Account.List.Sort {

    func toAPI() -> Components.Schemas.UserAccountListSort {
        switch self {
        case .email: .email
        }
    }
}

extension List.Result<
    User.Account.List.Item,
    User.Account.List.Sort
> {

    public func toAPI() -> Components.Schemas.UserAccountList {
        .init(
            items: items.map { $0.toAPI() },
            sort: query.sort?.toAPI(),
            order: query.order?.toAPI(),
            search: query.search,
            page: .init(size: query.page.size, index: query.page.index),
            count: count
        )
    }
}

extension User.Account.Reference {

    public func toAPI() -> Components.Schemas.UserAccountReference {
        .init(
            id: id.rawValue,
            email: email
        )
    }
}

extension User.Account.List.Item {

    public func toAPI() -> Components.Schemas.UserAccountListItem {
        .init(
            id: id.rawValue,
            email: email
        )
    }
}

extension User.Account.Detail {

    public func toAPI() -> Components.Schemas.UserAccountDetail {
        .init(
            id: id.rawValue,
            email: email,
            roles: roles.map { $0.toAPI() }
        )
    }
}

extension User.Account.Create {

    public func toAPI() -> Components.Schemas.UserAccountCreate {
        .init(
            email: email,
            password: password,
            roleKeys: roleKeys.map { $0.rawValue }
        )
    }
}

extension User.Account.Update {

    public func toAPI() -> Components.Schemas.UserAccountUpdate {
        .init(
            email: email,
            password: password,
            roleKeys: roleKeys.map { $0.rawValue }
        )
    }
}

extension User.Account.Patch {

    public func toAPI() -> Components.Schemas.UserAccountPatch {
        .init(
            email: email,
            password: password,
            roleKeys: roleKeys?.map { $0.rawValue }
        )
    }
}
