import FeatherOpenAPIKit

extension User.Role {

    enum Parameters {

        enum Key: PathParameter {
            static let name = "roleKey"
            static let description = "User role key"
            static let schema: Schema.Type = Schemas.Key.self
        }

        enum List {
            enum Sort: QueryParameter {
                static let name = "sort"
                static let description = "Sort by parameter"
                static let schema: Schema.Type = Schemas.List.Sort.self
            }
        }
    }
}
