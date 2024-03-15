//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 15/03/2024.
//

import CoreModule
import CoreModuleInterface
import UserModuleInterface
import DatabaseQueryKit
import FeatherValidation

extension User.Role {

    enum Validators {

        static func uniqueKey(
            _ value: ID<User.Role>,
            _ queryBuilder: User.Role.Query,
            _ originalKey: ID<User.Role>? = nil
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .unique(
                        queryBuilder: queryBuilder,
                        fieldKey: .key,
                        originalValue: originalKey
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
        _ queryBuilder: User.Role.Query
    ) async throws {
        let v = GroupValidator {
            User.Role.Validators.key(key.rawValue)
            User.Role.Validators.uniqueKey(key, queryBuilder)
        }
        try await v.validate()
    }
}

extension User.Role.Update {

    func validate(
        _ originalKey: ID<User.Role>,
        _ queryBuilder: User.Role.Query
    ) async throws {
        let v = GroupValidator {
            User.Role.Validators.key(key.rawValue)
            User.Role.Validators.uniqueKey(
                key,
                queryBuilder,
                originalKey
            )
        }
        try await v.validate()
    }
}

extension User.Role.Patch {

    func validate(
        _ originalKey: ID<User.Role>,
        _ queryBuilder: User.Role.Query
    ) async throws {
        let v = GroupValidator {
            if let key {
                User.Role.Validators.key(key.rawValue)
                User.Role.Validators.uniqueKey(
                    key,
                    queryBuilder,
                    originalKey
                )
            }
        }
        try await v.validate()
    }
}
