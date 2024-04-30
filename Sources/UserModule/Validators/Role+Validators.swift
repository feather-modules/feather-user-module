//
//  File.swift
//
//
//  Created by Tibor Bodecs on 15/03/2024.
//

import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import UserModuleKit

extension User.Role {

    enum Validators {

        static func uniqueKey(
            _ value: ID<User.Role>,
            on db: Database,
            _ originalKey: ID<User.Role>? = nil
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .unique(
                        Query.self,
                        column: .key,
                        originalValue: originalKey,
                        on: db
                    )
                ]
            )
        }

        static func key(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .nonempty(),
                    .min(length: 3),
                    .max(length: 64),
                ]
            )
        }
    }
}

extension User.Role.Create {

    func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.Role.Validators.key(key.rawValue)
            User.Role.Validators.uniqueKey(key, on: db)
        }
        try await v.validate()
    }
}

extension User.Role.Update {

    func validate(
        _ originalKey: ID<User.Role>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.Role.Validators.key(key.rawValue)
            User.Role.Validators.uniqueKey(
                key,
                on: db,
                originalKey
            )
        }
        try await v.validate()
    }
}

extension User.Role.Patch {

    func validate(
        _ originalKey: ID<User.Role>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            if let key {
                User.Role.Validators.key(key.rawValue)
                User.Role.Validators.uniqueKey(
                    key,
                    on: db,
                    originalKey
                )
            }
        }
        try await v.validate()
    }
}
