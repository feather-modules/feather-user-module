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

    struct Query: StandardQueryBuilderPrimaryKey {
        typealias Row = Model
        static var primaryKey = Model.FieldKeys.accountId
        let db: Database

        static let tableName = "user_account_password_reset"
    }
}
