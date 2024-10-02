import FeatherACL

extension Permission {

    static func userAccountGroup(_ action: Action) -> Self {
        .user("account-group", action: action)
    }
}

extension User.AccountGroup {

    public enum ACL: ACLSet {

        public static let detail: Permission = .userAccountGroup(.detail)
        public static let create: Permission = .userAccountGroup(.create)
        public static let update: Permission = .userAccountGroup(.update)
        public static let delete: Permission = .userAccountGroup(.delete)

        public static var all: [Permission] = [
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
        ]
    }
}
