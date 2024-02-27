//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/01/2024.
//

import DatabaseQueryKit
import FeatherRelationalDatabase
import SQLKit
import UserInterfaceKit

extension User.AccountRole {

    struct Query:
        InsertQueryBuilder,
        SelectQueryBuilder,
        ListQueryBuilder
    {
        typealias Row = Model
        typealias FieldKeys = Row.CodingKeys

        static let tableName = "user_account_role"
        let db: SQLDatabase
    }
}
