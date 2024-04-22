import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.Push {
    
    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.id),
            StringColumn(Model.ColumnNames.title),
            StringColumn(Model.ColumnNames.message),
            StringColumn(Model.ColumnNames.topic),
            DoubleColumn(Model.ColumnNames.date)
        ]
        public static let constraints: [DatabaseConstraintInterface] = []
    }

}
