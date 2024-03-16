//
//  File.swift
//
//
//  Created by Tibor Bodecs on 15/03/2024.
//

import CoreModule
import CoreModuleKit
import DatabaseQueryKit
import FeatherValidation
import UserModuleKit

extension User.Account {

    enum Validators {

        static func uniqueEmail(
            _ value: String,
            _ queryBuilder: User.Account.Query,
            _ originalEmail: String? = nil
        ) -> Validator {
            KeyValueValidator(
                key: "email",
                value: value,
                rules: [
                    .unique(
                        queryBuilder: queryBuilder,
                        fieldKey: .email,
                        originalValue: originalEmail
                    )
                ]
            )
        }

        static func email(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "email",
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

extension User.Account.Create {

    func validate(
        _ queryBuilder: User.Account.Query
    ) async throws {
        let v = GroupValidator {
            User.Account.Validators.email(email)
            User.Account.Validators.uniqueEmail(email, queryBuilder)
        }
        try await v.validate()
    }
}

extension User.Account.Update {

    func validate(
        _ originalEmail: String,
        _ queryBuilder: User.Account.Query
    ) async throws {
        let v = GroupValidator {
            User.Account.Validators.email(email)
            User.Account.Validators.uniqueEmail(
                email,
                queryBuilder,
                originalEmail
            )
        }
        try await v.validate()
    }
}

extension User.Account.Patch {

    func validate(
        _ originalEmail: String,
        _ queryBuilder: User.Account.Query
    ) async throws {
        let v = GroupValidator {
            if let email {
                User.Account.Validators.email(email)
                User.Account.Validators.uniqueEmail(
                    email,
                    queryBuilder,
                    originalEmail
                )
            }
        }
        try await v.validate()
    }
}
