//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import CoreInterfaceKit
import UserInterfaceKit

extension Components.Schemas.UserAccountListSort {

    public func toSDK() -> User.Account.List.Sort {
        switch self {
        case .email: .email
        }
    }
}

extension Operations.listUserAccount.Input.Query {

    public func toSDK() -> List.Query<User.Account.List.Sort> {
        .init(
            page: .init(
                size: pageSize,
                index: pageIndex
            ),
            search: search,
            sort: sort.flatMap { .init(rawValue: $0.rawValue) },
            order: order.flatMap { .init(rawValue: $0.rawValue) }
        )
    }
}

extension Components.Schemas.UserAccountReference {

    public func toSDK() -> User.Account.Reference {
        .init(
            id: .init(id),
            email: email
        )
    }
}

extension Components.Schemas.UserAccountListItem {

    public func toSDK() -> User.Account.List.Item {
        .init(
            id: .init(id),
            email: email
        )
    }
}

extension Components.Schemas.UserAccountDetail {

    public func toSDK() -> User.Account.Detail {
        .init(
            id: .init(id),
            email: email,
            roles: roles.map { $0.toSDK() }
        )
    }
}

extension Components.Schemas.UserAccountCreate {

    public func toSDK() -> User.Account.Create {
        .init(
            email: email,
            password: password,
            roleKeys: roleKeys.map { .init($0) }
        )
    }
}

extension Components.Schemas.UserAccountUpdate {

    public func toSDK() -> User.Account.Update {
        .init(
            email: email,
            password: password,
            roleKeys: roleKeys.map { .init($0) }
        )
    }
}

extension Components.Schemas.UserAccountPatch {

    public func toSDK() -> User.Account.Patch {
        .init(
            email: email,
            password: password,
            roleKeys: roleKeys?.map { .init($0) }
        )
    }
}
