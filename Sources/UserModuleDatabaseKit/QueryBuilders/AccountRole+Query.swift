//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/01/2024.
//

import DatabaseQueryKit
import FeatherRelationalDatabase
import SQLKit
import UserModuleKit

extension User.AccountRole {

    public struct Query: StandardQueryBuilderPrimaryKey {
        public typealias Row = Model
        public static var primaryKey = Model.FieldKeys.accountId
        public let db: Database

        public static let tableName = "user_account_role"

        public init(db: Database) {
            self.db = db
        }

    }
}
