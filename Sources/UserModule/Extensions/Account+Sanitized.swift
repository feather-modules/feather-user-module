//
//  File.swift
//
//
//  Created by Tibor Bodecs on 22/02/2024.
//

import Bcrypt
import UserModuleKit

extension String {

    fileprivate func hash() throws -> Self {
        try Bcrypt.hash(self)
    }
}

extension User.Account.Create {

    func sanitized() throws -> User.Account.Create {
        User.Account.Create(
            email: email.lowercased(),
            password: try password.hash(),
            firstName: firstName,
            lastName: lastName,
            imageKey: imageKey,
            roleKeys: roleKeys,
            groupIds: groupIds
        )
    }
}

extension User.Account.Update {

    func sanitized() throws -> User.Account.Update {
        .init(
            email: email.lowercased(),
            password: try password?.hash(),
            firstName: firstName,
            lastName: lastName,
            imageKey: imageKey,
            roleKeys: roleKeys,
            groupIds: groupIds
        )
    }
}

extension User.Account.Patch {

    func sanitized() throws -> User.Account.Patch {
        .init(
            email: email?.lowercased(),
            password: try password?.hash(),
            firstName: firstName,
            lastName: lastName,
            imageKey: imageKey,
            roleKeys: roleKeys,
            groupIds: groupIds
        )
    }
}

extension User.Password.Set {

    func sanitized() throws -> User.Password.Set {
        .init(
            password: try password.hash()
        )
    }
}
