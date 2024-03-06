//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreSDKInterface

extension User.Account: Identifiable {}

// MARK: -

public enum UserAccountListSortKeys: SortKeyInterface {
    case email
}

public protocol UserAccountListSort: Sortable
where
    Key == UserAccountListSortKeys
{
}

public protocol UserAccountListQuery: SimpleQueryInterface
where
    Sort: UserAccountListSort
{
}

public protocol UserAccountListItem: Codable {
    var id: ID<User.Account> { get }
    var email: String { get }
}

public protocol UserAccountList: SimpleList
where
    Query: UserAccountListQuery,
    Item: UserAccountListItem
{
}

// MARK: -

public protocol UserAccountReference: Codable {
    var id: ID<User.Account> { get }
    var email: String { get }
}

public protocol UserAccountDetail: Codable {
    var id: ID<User.Account> { get }
    var email: String { get }
    var roles: [UserRoleReference] { get }
}

public protocol UserAccountCreate: Codable {
    var email: String { get }
    var password: String { get }
    var roleKeys: [ID<User.Role>] { get }
}

public protocol UserAccountUpdate: Codable {
    var email: String { get }
    var password: String? { get }
    var roleKeys: [ID<User.Role>] { get }
}

public protocol UserAccountPatch: Codable {
    var email: String? { get }
    var password: String? { get }
    var roleKeys: [ID<User.Role>]? { get }
}
