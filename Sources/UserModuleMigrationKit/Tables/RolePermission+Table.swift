import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.RolePermission {
    
    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.roleKey),
            StringColumn(Model.ColumnNames.permissionKey)
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint(Model.ColumnNames.roleKey),
            UniqueConstraint(Model.ColumnNames.permissionKey)
        ]
    }

}
