import FeatherACL

extension Permission {

    static func userAccountInvitationType(_ action: Action) -> Self {
        .user("invitation-type", action: action)
    }
}

extension User.AccountInvitationType {

    public enum ACL: ACLSet {

        public static let list: Permission = .userAccountInvitationType(.list)

        public static var all: [Permission] = [
            Self.list
        ]
    }
}
