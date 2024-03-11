//
//  File.swift
//
//
//  Created by Tibor Bodecs on 22/02/2024.
//

import Bcrypt
import UserSDKInterface

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
            roleKeys: roleKeys
        )
    }
}

extension User.Account.Update {

    func sanitized() throws -> User.Account.Update {
        fatalError()
        //        User.Account.Update(
        //            email: email.lowercased(),
        //            password: try password.hash(),
        //            roleKeys: roleKeys
        //        )
    }
}

extension User.Account.Patch {

    func sanitized() throws -> User.Account.Patch {
        fatalError()
        //        .init(email: email?.lowercased(), password: try password?.hash())
    }
}

extension UserPasswordSet {

    func sanitized() throws -> UserPasswordSet {
        fatalError()
        //        .init(password: try password.hash())
    }
}
