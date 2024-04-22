//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherModuleKit
import Foundation

extension User.Push {

    public enum Topic: String, Object, CaseIterable {
        case message
        case documentShare
    }

    public struct Create: Object {
        public let title: String
        public let message: String
        public let recipients: [String]?

        public init(
            title: String,
            message: String,
            recipients: [String]?
        ) {
            self.title = title
            self.message = message
            self.recipients = recipients
        }
    }

    public struct List: FeatherModuleKit.List {

        public struct Query: Object {

            public struct Sort: Object {

                public enum Keys: SortKeyInterface {
                    case title
                    case message
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
                sort: User.Push.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let id: ID<User.Push>
            public let title: String
            public let message: String

            public init(id: ID<User.Push>, title: String, message: String) {
                self.id = id
                self.title = title
                self.message = message
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.Push.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Detail: Object {
        
        public let id: ID<User.Push>
        public let title: String
        public let message: String
        public let topic: Topic
        public let date: Date

        public init(
            id: ID<User.Push>,
            title: String,
            message: String,
            topic: Topic,
            date: Date
        ) {
            self.id = id
            self.title = title
            self.message = message
            self.topic = topic
            self.date = date
        }
    }

}
