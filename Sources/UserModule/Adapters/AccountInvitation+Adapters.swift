import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.AccountInvitation.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.AccountInvitation.List.Query.Sort.Key)
        throws
    {
        switch listQuerySortKeys {
        case .email:
            self = .email
        }
    }
}

extension User.AccountInvitation.List.Item: ListItemAdapter {
    public init(model: User.AccountInvitation.Model) throws {
        self.init(id: model.id.toID(), email: model.email)
    }
}

extension User.AccountInvitation.List: ListAdapter {
    public typealias Model = User.AccountInvitation.Model
}

extension User.AccountInvitation.Reference: ReferenceAdapter {
    public init(model: User.AccountInvitation.Model) throws {
        self.init(
            id: model.id.toID(),
            email: model.email
        )
    }
}
