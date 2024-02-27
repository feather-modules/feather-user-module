//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import UserInterfaceKit

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

    func toReference() -> User.Account.Reference {
        .init(id: .init(id), email: email)
    }

    func toDetail() -> User.Account.Detail {
        .init(id: .init(id), email: email)
    }

    func toListItem() -> User.Account.List.Item {
        .init(id: .init(id), email: email)
    }

}
