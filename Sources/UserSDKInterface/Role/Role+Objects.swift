//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

import CoreSDKInterface
import SystemSDKInterface

extension User.Role {

    public struct Reference: UserRoleReference {
        public let key: ID<User.Role>
        public let name: String

        public init(
            key: ID<User.Role>,
            name: String
        ) {
            self.key = key
            self.name = name
        }
    }

    public struct List: UserRoleList {

        public struct Query: UserRoleListQuery {

            public struct Sort: UserRoleListSort {
                public let by: UserRoleListSortKeys
                public let order: Order

                public init(by: UserRoleListSortKeys, order: Order) {
                    self.by = by
                    self.order = order
                }
            }

            public let search: String?
            public let sort: Sort
            public let page: Page

            public init(
                search: String? = nil,
                sort: User.Role.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: UserRoleListItem {
            public let key: ID<User.Role>
            public let name: String

            public init(key: ID<User.Role>, name: String) {
                self.key = key
                self.name = name
            }
        }

        public let items: [Item]
        public let query: Query
        public let page: Page
        public let count: UInt

        public init(
            items: [User.Role.List.Item],
            query: User.Role.List.Query,
            page: Page,
            count: UInt
        ) {
            self.items = items
            self.query = query
            self.page = page
            self.count = count
        }

    }

    public struct Detail: UserRoleDetail {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?
        public let permissions: [System.Permission.Reference]

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String? = nil,
            permissions: [System.Permission.Reference]
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.permissions = permissions
        }

        public var permissionReferences: [SystemPermissionReference] {
            permissions
        }
    }

    public struct Create: UserRoleCreate {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?
        public let permissionKeys: [ID<System.Permission>]

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String? = nil,
            permissionKeys: [ID<System.Permission>] = []
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.permissionKeys = permissionKeys
        }
    }

    public struct Update: UserRoleUpdate {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?
        public let permissionKeys: [ID<System.Permission>]

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String? = nil,
            permissionKeys: [ID<System.Permission>]
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.permissionKeys = permissionKeys
        }
    }

    public struct Patch: UserRolePatch {
        public let key: ID<User.Role>?
        public let name: String?
        public let notes: String?
        public let permissionKeys: [ID<System.Permission>]?

        public init(
            key: ID<User.Role>? = nil,
            name: String? = nil,
            notes: String? = nil,
            permissionKeys: [ID<System.Permission>]? = nil
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.permissionKeys = permissionKeys
        }
    }
}
