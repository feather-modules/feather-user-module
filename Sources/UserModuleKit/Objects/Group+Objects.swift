//
//  Group+Objects.swift
//
//  Created by gerp83 on 2024. 10. 01.
//

import FeatherModuleKit
import Foundation
import SystemModuleKit

extension User.Group {

    public struct Reference: Object {
        public let id: ID<User.Group>
        public let name: String

        public init(
            id: ID<User.Group>,
            name: String
        ) {
            self.id = id
            self.name = name
        }
    }

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case name
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
                sort: User.Group.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let id: ID<User.Group>
            public let name: String

            public init(
                id: ID<User.Group>,
                name: String
            ) {
                self.id = id
                self.name = name
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.Group.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct UserList: ListInterface {

        public struct Query: ListQueryInterface {

            public let search: String?
            public let sort: User.Account.List.Query.Sort
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
            public let id: ID<User.Group>
            public let account: User.Account.Reference

            public init(
                id: ID<User.Group>,
                account: User.Account.Reference
            ) {
                self.id = id
                self.account = account
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.Group.UserList.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Detail: Object {
        public let id: ID<User.Group>
        public let name: String

        public init(
            id: ID<User.Group>,
            name: String
        ) {
            self.id = id
            self.name = name
        }
    }

    public struct Create: Object {
        public let name: String

        public init(
            name: String
        ) {
            self.name = name
        }

    }

    public struct Update: Object {
        public let name: String

        public init(
            name: String
        ) {
            self.name = name
        }
    }

}
