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

        public static let delete: Permission = .userPushToken(.delete)
        public static let detail: Permission = .userPushToken(.detail)
        public static let create: Permission = .userPushToken(.create)
        public static let update: Permission = .userPushToken(.update)

        public static var all: [Permission] = [
            Self.delete,
            Self.detail,
            Self.create,
            Self.update,
        ]
    }
}
