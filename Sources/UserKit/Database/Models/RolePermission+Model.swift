import DatabaseQueryKit
import SystemInterfaceKit
import UserInterfaceKit

extension User {
    enum RolePermission {}
}

extension User.RolePermission {

    struct Model: Codable {

        enum CodingKeys: String, DatabaseQueryCodingKey {
            // user_role
            case roleKey = "role_key"
            // system_permission
            case permissionKey = "permission_key"
        }

        let roleKey: Key<User.Role>
        let permissionKey: Key<System.Permission>
    }
}
