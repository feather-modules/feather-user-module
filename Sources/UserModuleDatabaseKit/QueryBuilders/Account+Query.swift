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

    public struct Query: StandardQueryBuilderPrimaryKey {
        public typealias Row = Model
        public static var primaryKey = Model.FieldKeys.id
        public let db: Database

        public static let tableName = "user_account"

        public init(db: Database) {
            self.db = db
        }

        public func roleQueryBuilder() async throws -> User.AccountRole.Query {
            .init(db: db)
        }
    }
}
