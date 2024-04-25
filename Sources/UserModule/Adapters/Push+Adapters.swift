import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import UserModuleDatabaseKit
import UserModuleKit

extension User.Push.Model.ColumnNames: ModelColumnNamesInterface {
    public init(listQuerySortKeys: User.Push.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .title:
            self = .title
        case .message:
            self = .message
        }
    }
}

extension User.Push.List: ListInterface {
    public init(items: [User.Push.Model], count: UInt) throws {
        try self.init(
            items: items.map {
                .init(
                    id: $0.id,
                    title: $0.title,
                    message: $0.message,
                    topic: $0.topic,
                    date: $0.date
                )
            },
            count: count
        )
    }
}

extension User.Push.Detail: DetailInterface {
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

extension User.Push.List.Query: ListQueryInterface {}

extension User.Push.List.Query.Sort: ListQuerySortInterface {}
