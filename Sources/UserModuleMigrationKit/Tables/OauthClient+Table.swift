//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.OauthClient {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.id),
            StringColumn(Model.ColumnNames.name),
            StringColumn(Model.ColumnNames.type),
            StringColumn(Model.ColumnNames.clientSecret),
            StringColumn(Model.ColumnNames.redirectUri),
            StringColumn(Model.ColumnNames.loginRedirectUri),
            StringColumn(Model.ColumnNames.issuer),
            StringColumn(Model.ColumnNames.subject),
            StringColumn(Model.ColumnNames.audience),
            StringColumn(Model.ColumnNames.privateKey),
            StringColumn(Model.ColumnNames.publicKey),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint(Model.ColumnNames.id),
            UniqueConstraint(Model.ColumnNames.name),
            UniqueConstraint(Model.ColumnNames.clientSecret),
            UniqueConstraint(Model.ColumnNames.privateKey),
            UniqueConstraint(Model.ColumnNames.publicKey),
        ]
    }

}
