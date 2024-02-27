import FeatherKit

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

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String?
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }

    public struct Create: Codable {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String? = nil
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }

    public struct Patch: Codable {
        public let key: ID<User.Role>?
        public let name: String?
        public let notes: String?

        public init(
            key: ID<User.Role>? = nil,
            name: String? = nil,
            notes: String? = nil
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }

    public struct Update: Codable {
        public let key: ID<User.Role>
        public let name: String
        public let notes: String?

        public init(
            key: ID<User.Role>,
            name: String,
            notes: String?
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }

}
