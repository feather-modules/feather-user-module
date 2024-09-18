import UserModuleKit

extension User.Role.UserType? {
    func check() -> User.Role.UserType {
        if self == nil {
            return .open
        }
        return self!
    }
}

extension String {
    func toRoleType() -> User.Role.UserType {
        return User.Role.UserType(rawValue: self)!
    }
}
