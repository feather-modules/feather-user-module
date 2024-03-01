//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import CoreInterfaceKit
import UserInterfaceKit

extension User.Role.List.Sort {

    func toAPI() -> Components.Schemas.UserRoleListSort {
        switch self {
        case .name:
            .name
        case .key:
            .name
        }
    }
}

extension List.Result<
    User.Role.List.Item,
    User.Role.List.Sort
> {

    public func toAPI() -> Components.Schemas.UserRoleList {
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

extension User.Role.Reference {

    public func toAPI() -> Components.Schemas.UserRoleReference {
        .init(
            key: key.rawValue,
            name: name
        )
    }
}

extension User.Role.List.Item {

    public func toAPI() -> Components.Schemas.UserRoleListItem {
        .init(
            key: key.rawValue,
            name: name
        )
    }
}

extension User.Role.Detail {

    public func toAPI() -> Components.Schemas.UserRoleDetail {
        .init(
            key: key.rawValue,
            name: name,
            notes: notes,
            permissions: permissions.map {
                .init(key: .init($0.key.rawValue), name: $0.name)
            }
        )
    }
}

extension User.Role.Create {

    public func toAPI() -> Components.Schemas.UserRoleCreate {
        .init(
            key: key.rawValue,
            name: name,
            notes: notes,
            permissionKeys: []  // TODO
        )
    }
}

extension User.Role.Patch {

    public func toAPI() -> Components.Schemas.UserRolePatch {
        .init(
            key: key.map { $0.rawValue },
            name: name,
            notes: notes,
            permissionKeys: []  // TODO
        )
    }
}

extension User.Role.Update {

    public func toAPI() -> Components.Schemas.UserRoleUpdate {
        .init(
            key: key.rawValue,
            name: name,
            notes: notes,
            permissionKeys: []  // TODO
        )
    }
}
