//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherModuleKit
import Foundation

extension User.AccountInvitation {

    public struct Create: Object {

        public let email: String

        public init(
            email: String
        ) {
            self.email = email
        }
    }

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case email
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
                sort: User.AccountInvitation.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let id: ID<User.AccountInvitation>
            public let email: String

            public init(id: ID<User.AccountInvitation>, email: String) {
                self.id = id
                self.email = email
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.AccountInvitation.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Detail: Object {

        public let id: ID<User.AccountInvitation>
        public let email: String
        public let token: String
        public let expiration: Date

        public init(
            id: ID<User.AccountInvitation>,
            email: String,
            token: String,
            expiration: Date
        ) {
            self.id = id
            self.email = email
            self.token = token
            self.expiration = expiration
        }
    }

}
