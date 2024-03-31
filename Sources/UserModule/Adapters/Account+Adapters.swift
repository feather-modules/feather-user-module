import DatabaseQueryKit
import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Account.Model {

    func toReference() throws -> User.Account.Reference {
        .init(id: id.toID(), email: email)
    }

    func toListItem() throws -> User.Account.List.Item {
        .init(id: id.toID(), email: email)
    }
}
