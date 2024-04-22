import FeatherDatabase
import UserModuleKit
import SystemModuleKit

extension User.RolePermission {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            // user_role
            case roleKey = "role_key"
            // system_permission
            case permissionKey = "permission_key"
        }
        public static let tableName = "user_role_permission"
        public static let columnNames = CodingKeys.self

        public let roleKey: Key<User.Role>
        public let permissionKey: Key<System.Permission>

        public init(
            roleKey: Key<User.Role>,
            permissionKey: Key<System.Permission>
        ) {
            self.roleKey = roleKey
            self.permissionKey = permissionKey
        }
    }
}
