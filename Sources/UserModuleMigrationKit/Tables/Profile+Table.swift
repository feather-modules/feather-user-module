import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.Profile {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.accountId),
            StringColumn(Model.ColumnNames.firstName, isMandatory: false),
            StringColumn(Model.ColumnNames.lastName, isMandatory: false),
            StringColumn(Model.ColumnNames.imageKey, isMandatory: false),
            StringColumn(Model.ColumnNames.position, isMandatory: false),
            StringColumn(Model.ColumnNames.publicEmail, isMandatory: false),
            StringColumn(Model.ColumnNames.phone, isMandatory: false),
            StringColumn(Model.ColumnNames.web, isMandatory: false),
            DoubleColumn(Model.ColumnNames.lat, isMandatory: false),
            DoubleColumn(Model.ColumnNames.lon, isMandatory: false),
            DoubleColumn(Model.ColumnNames.lastLocationUpdate, isMandatory: false),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            PrimaryKeyConstraint(Model.ColumnNames.accountId),
            UniqueConstraint(Model.ColumnNames.accountId),
        ]
    }

}
