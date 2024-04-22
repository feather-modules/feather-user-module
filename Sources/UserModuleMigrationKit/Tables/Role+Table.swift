import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.Role {
    
    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.key),
            StringColumn(Model.ColumnNames.name),
            StringColumn(Model.ColumnNames.notes, isMandatory: false)
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint(Model.ColumnNames.key)
        ]
    }

}
