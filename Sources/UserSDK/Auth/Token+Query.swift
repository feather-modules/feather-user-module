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

extension User.Token {

    struct Query:
        QueryBuilderSchema,
        QueryBuilderAll,
        QueryBuilderCount,
        QueryBuilderDelete,
        QueryBuilderFirst,
        QueryBuilderInsert,
        QueryBuilderList,
        QueryBuilderPrimaryKey,
        QueryBuilderPrimaryKeyDelete,
        QueryBuilderPrimaryKeyGet,
        QueryBuilderPrimaryKeyUpdate
    {
        typealias Row = Model
        static var primaryKey = Model.FieldKeys.accountId
        let db: Database

        static let tableName = "user_token"
    }
}
