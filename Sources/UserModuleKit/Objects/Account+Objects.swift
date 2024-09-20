//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherModuleKit
import Foundation
import SystemModuleKit

extension User.Account {

    public struct Reference: Object {
        public let id: ID<User.Account>
        public let email: String
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?

        public init(
            id: ID<User.Account>,
            email: String,
            firstName: String?,
            lastName: String?,
            imageKey: String?
        ) {
            self.id = id
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
        }
    }

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case email
                    case firstName
                    case lastName
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
                sort: User.Account.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let id: ID<User.Account>
            public let email: String
            public let firstName: String?
            public let lastName: String?
            public let imageKey: String?

            public init(
                id: ID<User.Account>,
                email: String,
                firstName: String?,
                lastName: String?,
                imageKey: String?
            ) {
                self.id = id
                self.email = email
                self.firstName = firstName
                self.lastName = lastName
                self.imageKey = imageKey
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.Account.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Detail: Object {
        public let id: ID<User.Account>
        public let email: String
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?
        public let roles: [User.Role.Reference]
        public let permissions: [ID<System.Permission>]

        public init(
            id: ID<User.Account>,
            email: String,
            firstName: String?,
            lastName: String?,
            imageKey: String?,
            roles: [User.Role.Reference],
            permissions: [ID<System.Permission>]
        ) {
            self.id = id
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
            self.roles = roles
            self.permissions = permissions
        }
    }

    public struct Create: Object {
        public let email: String
        public let password: String
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?
        public let roleKeys: [ID<User.Role>]

        public init(
            email: String,
            password: String,
            firstName: String?,
            lastName: String?,
            imageKey: String?,
            roleKeys: [ID<User.Role>] = []
        ) {
            self.email = email
            self.password = password
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
            self.roleKeys = roleKeys
        }

    }

    public struct Update: Object {
        public let email: String
        public let password: String?
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?
        public let roleKeys: [ID<User.Role>]

        public init(
            email: String,
            password: String?,
            firstName: String?,
            lastName: String?,
            imageKey: String?,
            roleKeys: [ID<User.Role>]
        ) {
            self.email = email
            self.password = password
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
            self.roleKeys = roleKeys
        }
    }

    public struct Patch: Object {
        public let email: String?
        public let password: String?
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?
        public let roleKeys: [ID<User.Role>]?

        public init(
            email: String? = nil,
            password: String? = nil,
            firstName: String? = nil,
            lastName: String? = nil,
            imageKey: String? = nil,
            roleKeys: [ID<User.Role>]? = nil
        ) {
            self.email = email
            self.password = password
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
            self.roleKeys = roleKeys
        }
    }
}
