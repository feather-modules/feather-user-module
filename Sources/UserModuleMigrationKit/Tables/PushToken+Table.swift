import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.PushToken {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.accountId),
            StringColumn(Model.ColumnNames.token),
            StringColumn(Model.ColumnNames.platform),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint(Model.ColumnNames.accountId),
            UniqueConstraint(Model.ColumnNames.token),
            UniqueConstraint(Model.ColumnNames.platform),
        ]
    }

}
