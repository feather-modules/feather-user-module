import FeatherDatabase
import UserModuleKit

extension User.OauthClientRole {

    public struct Model: KeyedDatabaseModel {
        
        public typealias KeyType = Key<User.OauthClient>

        public enum CodingKeys: String, DatabaseColumnName {
            case clientId = "client_id"
            case roleKey = "role_key"
        }
        public static let tableName = "oauth_client_role"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.clientId

        public let clientId: KeyType
        public let roleKey: Key<User.OauthRole>

        public init(clientId: KeyType, roleKey: Key<User.OauthRole>) {
            self.clientId = clientId
            self.roleKey = roleKey
        }
    }
}
