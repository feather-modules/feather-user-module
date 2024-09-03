//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherACL

extension Permission {

    static func userOauthClient(_ action: Action) -> Self {
        .user("oauthClient", action: action)
    }
}

extension User.OauthClient {

    public enum ACL: ACLSet {

        public static let list: Permission = .userOauthClient(.list)
        public static let detail: Permission = .userOauthClient(.detail)
        public static let create: Permission = .userOauthClient(.create)
        public static let update: Permission = .userOauthClient(.update)
        public static let delete: Permission = .userOauthClient(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
        ]
    }
}
