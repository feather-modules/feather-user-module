//
//  Group+Validators.swift
//
//  Created by gerp83 on 2024. 10. 01.
//

import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
import UserModuleDatabaseKit
import UserModuleKit

extension User.Group {

    enum Validators {
        static func checkEmpty(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "name",
                value: value,
                rules: [
                    .nonempty()
                ]
            )
        }

        static func uniqueKey(
            _ value: String,
            on db: Database,
            _ originalKey: String? = nil
        ) -> Validator {
            KeyValueValidator(
                key: "name",
                value: value,
                rules: [
                    .unique(
                        Query.self,
                        column: .name,
                        originalValue: originalKey,
                        on: db
                    )
                ]
            )
        }

    }

}

extension User.Group.Create: CreateInterface {

    public func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.Group.Validators.checkEmpty(name)
            User.Group.Validators.uniqueKey(name, on: db)
        }
        try await v.validate()
    }
}

extension User.Group.Update {

    public func validate(
        _ originalName: String,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            User.Group.Validators.checkEmpty(name)
            User.Group.Validators.uniqueKey(
                name,
                on: db,
                originalName
            )
        }
        try await v.validate()
    }
}
