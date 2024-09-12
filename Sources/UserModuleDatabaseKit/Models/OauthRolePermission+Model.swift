import FeatherDatabase
import SystemModuleKit
import UserModuleKit

extension User.OauthRolePermission {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case roleKey = "role_key"
            case permissionKey = "permission_key"
        }
        public static let tableName = "oauth_role_permission"
        public static let columnNames = CodingKeys.self

        public let roleKey: Key<User.OauthRole>
        public let permissionKey: Key<System.Permission>

        public init(
            roleKey: Key<User.OauthRole>,
            permissionKey: Key<System.Permission>
        ) {
            self.roleKey = roleKey
            self.permissionKey = permissionKey
        }
    }

}
