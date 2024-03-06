//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/01/2024.
//

import DatabaseQueryKit
import FeatherRelationalDatabase
import SQLKit
import UserSDKInterface

extension User.AccountPasswordReset {

    struct Query:
        InsertQueryBuilder,
        SelectQueryBuilder,
        ListQueryBuilder,
        UpdateQueryBuilder,
        DeleteQueryBuilder
    {
        typealias Row = Model
        typealias FieldKeys = Row.CodingKeys

        static var idField: Row.CodingKeys = FieldKeys.accountId
        static let tableName = "user_account_password_reset"
        let db: SQLDatabase
    }
}
