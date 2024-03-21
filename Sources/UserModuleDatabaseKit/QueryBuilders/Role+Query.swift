//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import DatabaseQueryKit
import FeatherRelationalDatabase
import SQLKit
import UserModuleKit

extension User.Role {

    public struct Query: StandardQueryBuilderPrimaryKey {
        public typealias Row = Model
        public static var primaryKey = Model.FieldKeys.key
        public let db: Database

        public static let tableName = "user_role"

        public init(db: Database) {
            self.db = db
        }

        public func permissionQueryBuilder() async throws
            -> User.RolePermission.Query
        {
            .init(db: db)
        }
    }
}
