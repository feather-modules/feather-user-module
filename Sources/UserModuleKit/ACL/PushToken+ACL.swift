//
//  File.swift
//
//
//  Created by Tibor Bodecs on 28/02/2024.
//

import FeatherACL

extension Permission {

    static func userPushToken(_ action: Action) -> Self {
        .user("pushToken", action: action)
    }
}

extension User.PushToken {

    public enum ACL: ACLSet {

        public static let delete: Permission = .userPush(.delete)
        public static let detail: Permission = .userPush(.detail)
        public static let create: Permission = .userPush(.create)
        public static let update: Permission = .userPush(.update)

        public static var all: [Permission] = [
            Self.delete,
            Self.detail,
            Self.create,
            Self.update,
        ]
    }
}
