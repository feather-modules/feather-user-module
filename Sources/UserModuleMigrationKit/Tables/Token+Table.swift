import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.Token {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.value),
            StringColumn(Model.ColumnNames.accountId),
            DoubleColumn(Model.ColumnNames.expiration),
            DoubleColumn(Model.ColumnNames.lastAccess, isMandatory: false),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint(Model.ColumnNames.value)
        ]
    }

}
