import DatabaseQueryKit
import SystemSDKInterface
import UserSDKInterface

extension User {
    enum RolePermission {}
}

extension User.RolePermission {

    struct Model: QueryModel {

        enum CodingKeys: String, QueryFieldKey {
            // user_role
            case roleKey = "role_key"
            // system_permission
            case permissionKey = "permission_key"
        }
        static let fieldKeys = CodingKeys.self

        let roleKey: Key<User.Role>
        let permissionKey: Key<System.Permission>
    }
}
