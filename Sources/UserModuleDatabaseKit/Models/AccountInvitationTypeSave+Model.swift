import FeatherDatabase
import UserModuleKit

extension User.AccountInvitationTypeSave {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case invitationtId = "invitationt_id"
            case typeKey = "type_key"
        }
        public static let tableName = "user_account_invitation_type_save"
        public static let columnNames = CodingKeys.self

        public let invitationtId: Key<User.AccountInvitation>
        public let typeKey: Key<User.AccountInvitationType>

        public init(
            invitationtId: Key<User.AccountInvitation>,
            typeKey: Key<User.AccountInvitationType>
        ) {
            self.invitationtId = invitationtId
            self.typeKey = typeKey
        }
    }
}
