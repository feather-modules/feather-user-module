//
//  File.swift
//
//
//  Created by Tibor Bodecs on 15/03/2024.
//


import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
import UserModuleDatabaseKit
import UserModuleKit

extension User.Account {

    enum Validators {

        static func uniqueEmail(
            _ value: String,
            on db: Database,
            _ originalEmail: String? = nil
        ) -> Validator {
            KeyValueValidator(
                key: "email",
                value: value,
                rules: [
                    .unique(
                        Query.self,
                        column: .email,
                        originalValue: originalEmail,
                        on: db
                    )
                ]
            )
        }

        static func emailValid(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "email",
                value: value,
                rules: [
                    .email()
                ]
            )
        }
    }
}

extension User.Account.Create {

    func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.Account.Validators.emailValid(email)
            User.Account.Validators.uniqueEmail(email, on: db)
        }
        try await v.validate()
    }
}

extension User.Account.Update {

    func validate(
        _ originalEmail: String,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.Account.Validators.emailValid(email)
            User.Account.Validators.uniqueEmail(
                email,
                on: db,
                originalEmail
            )
        }
        try await v.validate()
    }
}

extension User.Account.Patch {

    func validate(
        _ originalEmail: String,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            if let email {
                User.Account.Validators.emailValid(email)
                User.Account.Validators.uniqueEmail(
                    email,
                    on: db,
                    originalEmail
                )
            }
        }
        try await v.validate()
    }
}
