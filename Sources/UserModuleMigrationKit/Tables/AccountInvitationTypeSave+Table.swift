import FeatherDatabase
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountInvitationTypeSave {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.invitationtId),
            StringColumn(Model.ColumnNames.typeKey),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint([Model.ColumnNames.invitationtId, Model.ColumnNames.typeKey])
        ]
    }

}
