import CoreModule
import CoreModuleKit
import DatabaseQueryKit
import FeatherComponent
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Role.Model {

    func toReference() throws -> User.Role.Reference {
        .init(key: key.toID(), name: name)
    }

    func toListItem() throws -> User.Role.List.Item {
        .init(key: key.toID(), name: name)
    }
}
