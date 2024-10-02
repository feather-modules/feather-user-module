import FeatherModuleKit
import SystemModuleKit

extension User.AccountGroup {

    public struct Detail: Object {
        public let accountId: ID<User.Account>
        public let groupId: ID<User.Group>

        public init(
            accountId: ID<User.Account>,
            groupId: ID<User.Group>
        ) {
            self.accountId = accountId
            self.groupId = groupId
        }
    }

    public struct Create: Object {
        public let accountId: ID<User.Account>
        public let groupId: ID<User.Group>

        public init(
            accountId: ID<User.Account>,
            groupId: ID<User.Group>
        ) {
            self.accountId = accountId
            self.groupId = groupId
        }
    }

    public struct Update: Object {
        public let accountId: ID<User.Account>
        public let groupId: ID<User.Group>

        public init(
            accountId: ID<User.Account>,
            groupId: ID<User.Group>
        ) {
            self.accountId = accountId
            self.groupId = groupId
        }
    }

}
