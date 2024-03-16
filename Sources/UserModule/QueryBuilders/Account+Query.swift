//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

import DatabaseQueryKit
import FeatherRelationalDatabase
import SQLKit
import UserModuleKit

extension User.Account {

    struct Query: StandardQueryBuilderPrimaryKey {
        typealias Row = Model
        static var primaryKey = Model.FieldKeys.id
        let db: Database

        static let tableName = "user_account"

        // MARK: -

        func roleQueryBuilder() async throws -> User.AccountRole.Query {
            .init(db: db)
        }
    }
}
