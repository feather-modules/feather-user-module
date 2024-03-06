//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import SystemSDKInterface
import UserSDKInterface

extension User.Role.Model {

    init(_ input: User.Role.Create) {
        self.key = .init(input.key.rawValue)
        self.name = input.name
        self.notes = input.notes
    }

    func updated(_ input: User.Role.Update) -> Self {
        .init(
            key: .init(input.key.rawValue),
            name: input.name,
            notes: input.notes
        )
    }

    func patched(_ input: User.Role.Patch) -> Self {
        .init(
            key: input.key.map { .init($0.rawValue) } ?? key,
            name: input.name ?? name,
            notes: input.notes ?? notes
        )
    }

    // MARK: -

    func toReference() -> User.Role.Reference {
        .init(key: .init(key.rawValue), name: name)
    }

    func toDetail(
        permissions: [System.Permission.Reference]
    ) -> User.Role.Detail {
        .init(
            key: .init(key.rawValue),
            name: name,
            notes: notes,
            permissions: permissions
        )
    }

    func toListItem() -> User.Role.List.Item {
        .init(
            key: .init(key.rawValue),
            name: name
        )
    }

}
