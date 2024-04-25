import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountPasswordReset {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.accountId),
            StringColumn(Model.ColumnNames.token),
            DoubleColumn(Model.ColumnNames.expiration),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint(Model.ColumnNames.accountId)
        ]
    }
}
