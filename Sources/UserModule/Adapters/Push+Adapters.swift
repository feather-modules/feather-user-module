import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Push.Model {

    func toListItem() throws -> User.Push.List.Item {
        .init(
            id: id.toID(),
            title: title,
            message: message
        )
    }

}
