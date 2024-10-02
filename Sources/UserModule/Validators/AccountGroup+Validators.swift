//
//  AccountGroup+Validators.swift
//
//  Created by gerp83 on 2024. 10. 02.
//

import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountGroup {

    enum Validators {

        static func checkLength(
            _ key: String,
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: key,
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

extension User.AccountGroup.Create: CreateInterface {

    public func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.AccountGroup.Validators.checkLength(
                "groupId",
                groupId.rawValue
            )
            User.AccountGroup.Validators.checkLength(
                "accountId",
                accountId.rawValue
            )
        }
        try await v.validate()
    }
}

extension User.AccountGroup.Update: UpdateInterface {

    public func validate(
        _ originalKey: ID<User.Account>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.AccountGroup.Validators.checkLength(
                "groupId",
                groupId.rawValue
            )
            User.AccountGroup.Validators.checkLength(
                "accountId",
                accountId.rawValue
            )
        }
        try await v.validate()
    }
}
