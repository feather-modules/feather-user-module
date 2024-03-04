import CoreInterfaceKit
import SystemInterfaceKit

extension User.Role {

    public struct Reference: Codable {
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

    public enum List {

        public enum Sort: String, Codable {
            case key
            case name
        }

        public struct Item: Codable {
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
    }

    public struct Detail: Codable {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?
        public let permissions: [System.Permission.Reference]

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String?,
            permissions: [System.Permission.Reference]
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.permissions = permissions
        }
    }

    public struct Create: Codable {
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

    public struct Patch: Codable {
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

    public struct Update: Codable {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?
        public let permissionKeys: [ID<System.Permission>]

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String?,
            permissionKeys: [ID<System.Permission>]
        ) {
            self.key = key
            self.name = name
            self.notes = notes
            self.permissionKeys = permissionKeys
        }
    }

}
