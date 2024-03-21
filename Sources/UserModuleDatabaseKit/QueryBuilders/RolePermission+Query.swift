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

extension User.RolePermission {

    public struct Query: StandardQueryBuilderPrimaryKey {
        public typealias Row = Model
        public static var primaryKey = Model.FieldKeys.roleKey
        public let db: Database

        public static let tableName = "user_role_permission"

        public init(db: Database) {
            self.db = db
        }
    }
}
