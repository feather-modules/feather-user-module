import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountGroup {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.accountId),
            StringColumn(Model.ColumnNames.groupId),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint([
                Model.ColumnNames.accountId, Model.ColumnNames.groupId,
            ])
        ]
    }

}
