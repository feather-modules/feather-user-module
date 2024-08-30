import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import SystemModuleKit
import UserModuleDatabaseKit
import UserModuleKit

extension User.Profile.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.Profile.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .firstName:
            self = .firstName
        case .lastName:
            self = .lastName
        }
    }
}

extension User.Profile.List.Item: ListItemAdapter {
    public init(model: User.Profile.Model) throws {
        self.init(
            accountId: model.accountId.toID(),
            firstName: model.firstName,
            lastName: model.lastName
        )
    }
}

extension User.Profile.List: ListAdapter {
    public typealias Model = User.Profile.Model
}

extension User.Profile.Reference: ReferenceAdapter {
    public init(model: User.Profile.Model) throws {
        self.init(
            accountId: model.accountId.toID(),
            firstName: model.firstName,
            lastName: model.lastName
        )
    }
}

extension User.Profile.Model {
    func toDetail() -> User.Profile.Detail {
        .init(
            accountId: self.accountId.toID(),
            firstName: self.firstName,
            lastName: self.lastName,
            imageKey: self.imageKey,
            position: self.position,
            publicEmail: self.publicEmail,
            phone:self.phone,
            web: self.web,
            lat: self.lat,
            lon: self.lon,
            lastLocationUpdate: self.lastLocationUpdate
        )
    }
}
