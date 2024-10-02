import FeatherACL

extension Permission {

    static func userGroup(_ action: Action) -> Self {
        .user("group", action: action)
    }
}

extension User.Group {

    public enum ACL: ACLSet {

        public static let list: Permission = .userGroup(.list)
        public static let detail: Permission = .userGroup(.detail)
        public static let create: Permission = .userGroup(.create)
        public static let update: Permission = .userGroup(.update)
        public static let delete: Permission = .userGroup(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
        ]
    }
}
