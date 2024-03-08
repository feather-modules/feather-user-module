//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import CoreSDKInterface
import SystemSDKInterface

extension User.Account {

    public struct Reference: UserAccountReference {
        public let id: ID<User.Account>
        public let email: String

        public init(
            id: ID<User.Account>,
            email: String
        ) {
            self.id = id
            self.email = email
        }
    }

    public struct List: UserAccountList {

        public struct Query: UserAccountListQuery {

            public struct Sort: UserAccountListSort {
                public let by: UserAccountListSortKeys
                public let order: Order

                public init(by: UserAccountListSortKeys, order: Order) {
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

        public struct Item: UserAccountListItem {
            public let id: ID<User.Account>
            public let email: String

            public init(
                id: ID<User.Account>,
                email: String
            ) {
                self.id = id
                self.email = email
            }
        }

        public let items: [Item]
        public let query: Query
        public let page: Page
        public let count: UInt

        public init(
            items: [User.Account.List.Item],
            query: User.Account.List.Query,
            page: Page,
            count: UInt
        ) {
            self.items = items
            self.query = query
            self.page = page
            self.count = count
        }

    }

    public struct Detail: UserAccountDetail {
        public let id: ID<User.Account>
        public let email: String
        public let roleReferences: [User.Role.Reference]
        public var roles: [UserRoleReference] { roleReferences }

        public init(
            id: ID<User.Account>,
            email: String,
            roleReferences: [User.Role.Reference]
        ) {
            self.id = id
            self.email = email
            self.roleReferences = roleReferences
        }
    }

    public struct Create: UserAccountCreate {
        public let email: String
        public let password: String
        public let roleKeys: [ID<User.Role>]

        public init(
            email: String,
            password: String,
            roleKeys: [ID<User.Role>] = []
        ) {
            self.email = email
            self.password = password
            self.roleKeys = roleKeys
        }

    }
    //
    //    public struct Update: Codable {
    //        public let email: String
    //        public let password: String?
    //        public let roleKeys: [ID<User.Role>]
    //
    //        public init(
    //            email: String,
    //            password: String? = nil,
    //            roleKeys: [ID<User.Role>] = []
    //        ) {
    //            self.email = email
    //            self.password = password
    //            self.roleKeys = roleKeys
    //        }
    //
    //    }
    //
    //    public struct Patch: Codable {
    //        public let email: String?
    //        public let password: String?
    //        public let roleKeys: [ID<User.Role>]?
    //
    //        public init(
    //            email: String? = nil,
    //            password: String? = nil,
    //            roleKeys: [ID<User.Role>]? = nil
    //        ) {
    //            self.email = email
    //            self.password = password
    //            self.roleKeys = roleKeys
    //        }
    //    }
}
