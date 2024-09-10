import FeatherDatabase
import UserModuleKit

extension User.OauthClientRole {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case clientId = "client_id"
            case roleKey = "role_key"
        }
        public static let tableName = "user_oauth_client_role"
        public static let columnNames = CodingKeys.self

        public let clientId: Key<User.OauthClient>
        public let roleKey: Key<User.Role>

        public init(clientId: Key<User.OauthClient>, roleKey: Key<User.Role>) {
            self.clientId = clientId
            self.roleKey = roleKey
        }
    }
}
