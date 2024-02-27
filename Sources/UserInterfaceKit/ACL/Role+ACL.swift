//
//  File.swift
//
//
//  Created by Tibor Bodecs on 27/02/2024.
//

extension User.Role {

    public enum ACL: String {
        case list = "user.role.list"
        case get = "user.role.get"
        case create = "user.role.create"
        case update = "user.role.update"
        case delete = "user.role.delete"
    }
}
