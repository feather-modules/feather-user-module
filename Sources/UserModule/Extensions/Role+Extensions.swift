import UserModuleKit

extension User.Role.RoleType? {
    func check() -> User.Role.RoleType {
        if self == nil {
            return .open
        }
        return self!
    }
}

extension String {
    func toRoleType() -> User.Role.RoleType {
        User.Role.RoleType(rawValue: self)!
    }
}
