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

extension User.AccountInvitation {

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

extension User.AccountInvitation.Create {

    public func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.Account.Validators.emailValid(email)
            User.Account.Validators.uniqueEmail(email, on: db)
        }
        try await v.validate()
    }
}
