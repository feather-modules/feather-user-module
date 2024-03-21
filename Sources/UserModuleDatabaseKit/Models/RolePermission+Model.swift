import DatabaseQueryKit
import SystemModuleKit
import UserModuleKit

extension User.RolePermission {

    public struct Model: QueryModel {

        public enum CodingKeys: String, QueryFieldKey {
            // user_role
            case roleKey = "role_key"
            // system_permission
            case permissionKey = "permission_key"
        }
        public static let fieldKeys = CodingKeys.self

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
