import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Push.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: User.Push.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .title:
            self = .title
        case .message:
            self = .message
        }
    }
}

extension User.Push.List.Item: ListItemAdapter {
    public init(model: User.Push.Model) throws {
        self.init(
            id: model.id.toID(),
            title: model.title,
            message: model.message
        )
    }
}

extension User.Push.List: ListAdapter {
    public typealias Model = User.Push.Model
}

extension User.Push.Detail: DetailAdapter {
    public init(model: User.Push.Model) throws {
        self.init(
            id: model.id.toID(),
            title: model.title,
            message: model.message,
            topic: User.Push.Topic(rawValue: model.topic)!,
            date: model.date
        )
    }
}
