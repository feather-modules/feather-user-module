//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

extension User.Account {

    public enum ACL: String, CaseIterable {
        case list = "user.account.list"
        case get = "user.account.get"
        case create = "user.account.create"
        case update = "user.account.update"
        case delete = "user.account.delete"
    }
}
