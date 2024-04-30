import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.Account {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.id),
            StringColumn(Model.ColumnNames.email),
            StringColumn(Model.ColumnNames.password),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            PrimaryKeyConstraint(Model.ColumnNames.id),
            UniqueConstraint(Model.ColumnNames.email),
        ]
    }

}
