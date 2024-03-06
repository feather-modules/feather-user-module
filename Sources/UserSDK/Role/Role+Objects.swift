//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

import CoreSDKInterface
import SystemSDKInterface
import UserSDKInterface

extension User.Role {

    struct Reference: UserRoleReference {
        let key: ID<User.Role>
        let name: String
    }

    struct List: UserRoleList {

        struct Query: UserRoleListQuery {

            struct Sort: UserRoleListSort {
                let by: UserRoleListSortKeys
                let order: Order
            }

            let search: String?
            let sort: Sort
            let page: Page
        }

        struct Item: UserRoleListItem, Equatable, Hashable {
            let key: ID<User.Role>
            let name: String
        }

        let items: [Item]
        let query: Query
        let page: Page
        let count: UInt

    }

    struct Detail: UserRoleDetail {
        let key: ID<User.Role>
        let name: String
        let notes: String?
        let permissions: [SystemPermissionReference]
    }

    struct Create: UserRoleCreate {
        let key: ID<User.Role>
        let name: String
        let notes: String?
        let permissionKeys: [ID<System.Permission>]
    }

    struct Update: UserRoleUpdate {
        let key: ID<User.Role>
        let name: String
        let notes: String?
        let permissionKeys: [ID<System.Permission>]
    }

    struct Patch: UserRolePatch {
        let key: ID<User.Role>?
        let name: String?
        let notes: String?
        let permissionKeys: [ID<System.Permission>]?
    }
}
