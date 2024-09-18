//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/03/2024.
//

import FeatherModuleKit
import SystemModuleKit

extension User.Role {

    public enum RoleType: String, Object, CaseIterable {
        case open
        case protected
    }

    public struct Reference: Object {
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

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case key
                    case name
                    case type
                }

                public let by: Keys
                public let order: Order

                public init(by: Keys, order: Order) {
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

        public struct Item: Object {
            public let key: ID<User.Role>
            public let name: String
            public let type: RoleType

            public init(key: ID<User.Role>, name: String, type: RoleType) {
                self.key = key
                self.name = name
                self.type = type
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.Role.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Detail: Object {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?
        public let type: RoleType
        public let permissions: [System.Permission.Reference]

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String? = nil,
            type: RoleType,
            permissions: [System.Permission.Reference]
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.type = type
            self.permissions = permissions
        }
    }

    public struct Create: Object {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?
        public let type: RoleType?
        public let permissionKeys: [ID<System.Permission>]

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String? = nil,
            type: RoleType? = nil,
            permissionKeys: [ID<System.Permission>] = []
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.type = type
            self.permissionKeys = permissionKeys
        }
    }

    public struct Update: Object {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?
        public let type: RoleType?
        public let permissionKeys: [ID<System.Permission>]

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String? = nil,
            type: RoleType? = nil,
            permissionKeys: [ID<System.Permission>]
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.type = type
            self.permissionKeys = permissionKeys
        }
    }

    public struct Patch: Object {
        public let key: ID<User.Role>?
        public let name: String?
        public let notes: String?
        public let type: RoleType?
        public let permissionKeys: [ID<System.Permission>]?

        public init(
            key: ID<User.Role>? = nil,
            name: String? = nil,
            notes: String? = nil,
            type: RoleType? = nil,
            permissionKeys: [ID<System.Permission>]? = nil
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.type = type
            self.permissionKeys = permissionKeys
        }
    }
}
