//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import DatabaseQueryKit
import FeatherRelationalDatabase
import SQLKit
import UserSDKInterface

extension User.Role {

    struct Query:
        InsertQueryBuilder,
        SelectQueryBuilder,
        ListQueryBuilder,
        UpdateQueryBuilder,
        DeleteQueryBuilder
    {
        typealias Row = Model
        typealias FieldKeys = Row.CodingKeys

        static let idField = FieldKeys.key
        static let tableName = "user_role"
        let db: SQLDatabase
    }
}
