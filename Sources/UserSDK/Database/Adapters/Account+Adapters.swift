//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import CoreSDKInterface
import UserSDKInterface

extension User.Account.Model {

    init(_ input: User.Account.Create.Sanitized) {
        self.id = .generate()
        self.email = input.email
        self.password = input.password
    }

    func updated(_ input: User.Password.Set.Sanitized) -> Self {
        .init(
            id: id,
            email: email,
            password: input.password
        )
    }

    func updated(_ input: User.Account.Update.Sanitized) -> Self {
        .init(
            id: id,
            email: input.email,
            password: input.password ?? password
        )
    }

    func patched(_ input: User.Account.Patch.Sanitized) -> Self {
        .init(
            id: id,
            email: input.email ?? email,
            password: input.password ?? password
        )
    }

    // MARK: -

    func toReference() -> UserAccountReference {
        MyUserAccountReference(id: .init(id), email: email)
    }

    func toDetail(roles: [User.Role.Reference]) -> User.Account.Detail {
        .init(id: .init(id), email: email, roles: roles)
    }

    func toListItem() -> User.Account.List.Item {
        .init(id: .init(id), email: email)
    }

}

struct MyUserAccountReference: UserAccountReference {
    var id: CoreInterfaceKit.ID<UserSDKInterface.User.Account>
    var email: String
}
