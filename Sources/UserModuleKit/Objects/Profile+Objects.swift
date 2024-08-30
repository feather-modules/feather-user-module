import FeatherModuleKit
import SystemModuleKit
import Foundation

extension User.Profile {
    
    public struct Reference: Object {
        public let accountId: ID<User.Account>
        public let firstName: String?
        public let lastName: String?

        public init(
            accountId: ID<User.Account>,
            firstName: String?,
            lastName: String?
        ) {
            self.accountId = accountId
            self.firstName = firstName
            self.lastName = lastName
        }
    }
    
    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
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
                sort: User.Profile.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let accountId: ID<User.Account>
            public let firstName: String?
            public let lastName: String?

            public init(
                accountId: ID<User.Account>,
                firstName: String?,
                lastName: String?
            ) {
                self.accountId = accountId
                self.firstName = firstName
                self.lastName = lastName
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.Profile.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }
    
    public struct Detail: Object {
        public let accountId: ID<User.Account>
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?
        public let position: String?
        public let publicEmail: String?
        public let phone: String?
        public let web: String?
        public let lat: Double?
        public let lon: Double?
        public let lastLocationUpdate: Date?

        public init(
            accountId: ID<User.Account>,
            firstName: String?,
            lastName: String?,
            imageKey: String?,
            position: String?,
            publicEmail: String?,
            phone: String?,
            web: String?,
            lat: Double?,
            lon: Double?,
            lastLocationUpdate: Date?
        ) {
            self.accountId = accountId
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
            self.position = position
            self.publicEmail = publicEmail
            self.phone = phone
            self.web = web
            self.lat = lat
            self.lon = lon
            self.lastLocationUpdate = lastLocationUpdate
        }
    }
    
    public struct Create: Object {
        public let accountId: ID<User.Account>
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?
        public let position: String?
        public let publicEmail: String?
        public let phone: String?
        public let web: String?
        public let lat: Double?
        public let lon: Double?
        public let lastLocationUpdate: Date?

        public init(
            accountId: ID<User.Account>,
            firstName: String?,
            lastName: String?,
            imageKey: String?,
            position: String?,
            publicEmail: String?,
            phone: String?,
            web: String?,
            lat: Double?,
            lon: Double?,
            lastLocationUpdate: Date?
        ) {
            self.accountId = accountId
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
            self.position = position
            self.publicEmail = publicEmail
            self.phone = phone
            self.web = web
            self.lat = lat
            self.lon = lon
            self.lastLocationUpdate = lastLocationUpdate
        }
    }
    
    public struct Update: Object {
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?
        public let position: String?
        public let publicEmail: String?
        public let phone: String?
        public let web: String?
        public let lat: Double?
        public let lon: Double?
        public let lastLocationUpdate: Date?

        public init(
            firstName: String?,
            lastName: String?,
            imageKey: String?,
            position: String?,
            publicEmail: String?,
            phone: String?,
            web: String?,
            lat: Double?,
            lon: Double?,
            lastLocationUpdate: Date?
        ) {
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
            self.position = position
            self.publicEmail = publicEmail
            self.phone = phone
            self.web = web
            self.lat = lat
            self.lon = lon
            self.lastLocationUpdate = lastLocationUpdate
        }
    }
    
    public struct Patch: Object {
        public let firstName: String?
        public let lastName: String?
        public let imageKey: String?
        public let position: String?
        public let publicEmail: String?
        public let phone: String?
        public let web: String?
        public let lat: Double?
        public let lon: Double?
        public let lastLocationUpdate: Date?

        public init(
            firstName: String? = nil,
            lastName: String? = nil,
            imageKey: String? = nil,
            position: String? = nil,
            publicEmail: String? = nil,
            phone: String? = nil,
            web: String? = nil,
            lat: Double? = nil,
            lon: Double? = nil ,
            lastLocationUpdate: Date? = nil
        ) {
            self.firstName = firstName
            self.lastName = lastName
            self.imageKey = imageKey
            self.position = position
            self.publicEmail = publicEmail
            self.phone = phone
            self.web = web
            self.lat = lat
            self.lon = lon
            self.lastLocationUpdate = lastLocationUpdate
        }
    }
    
}
