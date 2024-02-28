import DatabaseQueryKit
import FeatherRelationalDatabase
import SQLKit
import UserInterfaceKit

extension User.Account {

    struct AccountRoles {
        struct Query:
            JointListQueryBuilder
        {
            
            typealias ConnectorID = Key<User.Account>
            typealias ConnectorBuilder = User.Role.Query
            typealias ValueBuilder = User.AccountRole.Query

            static let referenceField = ConnectorBuilder.FieldKeys.key
            static let connectorField = ConnectorBuilder.FieldKeys.key
            static let valueField = ValueBuilder.FieldKeys.accountId
            static let idField = valueField

            let db: SQLDatabase
            let accountId: Key<User.Account>
            var connectorId: ConnectorID { accountId }
        }
    }
    
    /*
     SELECT
     user_roles.*
     FROM user_roles
     JOIN user_account_roles
     ON user_roles.id = user_account_roles.role_id
     WHERE user_account_roles.account_id = ?
     */
}
