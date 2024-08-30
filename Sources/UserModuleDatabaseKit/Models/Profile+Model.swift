import FeatherDatabase
import UserModuleKit
import Foundation

extension User.Profile {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<User.Account>

        public enum CodingKeys: String, DatabaseColumnName {
            case accountId = "account_id"
            case firstName = "first_name"
            case lastName = "last_name"
            case imageKey = "image_key"
            case position
            case publicEmail = "public_email"
            case phone
            case web
            case lat
            case lon
            case lastLocationUpdate = "last_location_update"
        }

        public static let tableName = "user_profile"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.accountId

        public let accountId: KeyType
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
            accountId: KeyType,
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
}
