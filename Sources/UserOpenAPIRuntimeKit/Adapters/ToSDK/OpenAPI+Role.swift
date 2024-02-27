//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 06/02/2024.
//

import FeatherKit
import UserInterfaceKit

extension Components.Schemas.UserRoleListSort {

    public func toSDK() -> User.Role.List.Sort {
        switch self {
        case .key: .key
        case .name: .name
        }
    }
}

extension Operations.listUserRole.Input.Query {

    public func toSDK() -> List.Query<User.Role.List.Sort> {
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

extension Components.Schemas.UserRoleReference {

    public func toSDK() -> User.Role.Reference {
        .init(
            key: .init(key),
            name: name
        )
    }
}

extension Components.Schemas.UserRoleListItem {

    public func toSDK() -> User.Role.List.Item {
        .init(
            key: .init(key),
            name: name
        )
    }
}

extension Components.Schemas.UserRoleDetail {

    public func toSDK() -> User.Role.Detail {
        .init(
            key: .init(key),
            name: name,
            notes: notes
        )
    }
}

extension Components.Schemas.UserRoleCreate {

    public func toSDK() -> User.Role.Create {
        .init(
            key: .init(key),
            name: name,
            notes: notes
        )
    }
}

extension Components.Schemas.UserRolePatch {

    public func toSDK() -> User.Role.Patch {
        .init(
            key: key.map { .init($0) },
            name: name,
            notes: notes
        )
    }
}

extension Components.Schemas.UserRoleUpdate {

    public func toSDK() -> User.Role.Update {
        .init(
            key: .init(key),
            name: name,
            notes: notes
        )
    }
}
