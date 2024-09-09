//
//  File.swift
//
//  Created by gerp83 on 04/09/2024
//

import FeatherModuleKit
import Foundation

extension User.AccountInvitationType {

    public enum InvitationType: String, Object, CaseIterable {
        case drive
        case lms
        case intranet
    }

    public struct Reference: Object {
        public let key: ID<User.AccountInvitationType>
        public let title: String

        public init(
            key: ID<User.AccountInvitationType>,
            title: String
        ) {
            self.key = key
            self.title = title
        }
    }

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case title
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
                sort: User.AccountInvitationType.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let key: ID<User.AccountInvitationType>
            public let title: String

            public init(key: ID<User.AccountInvitationType>, title: String) {
                self.key = key
                self.title = title
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.AccountInvitationType.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Create: Object {
        public let key: ID<User.AccountInvitationType>
        public let title: String

        public init(
            key: ID<User.AccountInvitationType>,
            title: String
        ) {
            self.key = key
            self.title = title
        }
    }

    public struct Detail: Object {
        public let key: ID<User.AccountInvitationType>
        public let title: String

        public init(
            key: ID<User.AccountInvitationType>,
            title: String
        ) {
            self.key = key
            self.title = title
        }
    }

}
