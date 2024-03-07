//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import CoreSDKInterface
import SystemSDKInterface

extension User.Role: Identifiable {}

// MARK: -

public enum UserRoleListSortKeys: SortKeyInterface {
    case key
    case name
}

public protocol UserRoleListSort: Sortable
where
    Key == UserRoleListSortKeys
{
}

public protocol UserRoleListQuery: SimpleQueryInterface
where
    Sort: UserRoleListSort
{
}

public protocol UserRoleListItem: Sendable, Codable, Equatable, Hashable {
    var key: ID<User.Role> { get }
    var name: String { get }
}

public protocol UserRoleList: SimpleList
where
    Query: UserRoleListQuery,
    Item: UserRoleListItem
{
}

// MARK: -

public protocol UserRoleReference: Codable {
    var key: ID<User.Role> { get }
    var name: String { get }
}

public protocol UserRoleDetail: Codable {
    var key: ID<User.Role> { get }
    var name: String { get }
    var notes: String? { get }
    var permissionReferences: [SystemPermissionReference] { get }
}

public protocol UserRoleCreate: Codable {
    var key: ID<User.Role> { get }
    var name: String { get }
    var notes: String? { get }
    var permissionKeys: [ID<System.Permission>] { get }
}

public protocol UserRoleUpdate: Codable {
    var key: ID<User.Role> { get }
    var name: String { get }
    var notes: String? { get }
    var permissionKeys: [ID<System.Permission>] { get }
}

public protocol UserRolePatch: Codable {
    var key: ID<User.Role>? { get }
    var name: String? { get }
    var notes: String? { get }
    var permissionKeys: [ID<System.Permission>]? { get }
}
