import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.AuthorizationCode {
    
    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.id),
            StringColumn(Model.ColumnNames.expiration),
            StringColumn(Model.ColumnNames.value),
            StringColumn(Model.ColumnNames.accountId),
            StringColumn(Model.ColumnNames.clientId),
            StringColumn(Model.ColumnNames.redirectUrl),
            StringColumn(Model.ColumnNames.scope),
            StringColumn(Model.ColumnNames.state, isMandatory: false),
            StringColumn(Model.ColumnNames.codeChallenge, isMandatory: false),
            StringColumn(Model.ColumnNames.codeChallengeMethod, isMandatory: false),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint([Model.ColumnNames.id])
        ]
    }

}
