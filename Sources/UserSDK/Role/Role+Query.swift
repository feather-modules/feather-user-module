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

    struct Query: StandardQueryBuilderPrimaryKey {
        typealias Row = Model
        static var primaryKey = Model.FieldKeys.key
        let db: Database

        static let tableName = "user_role"
    }
}
