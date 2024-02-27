import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Account {

    enum Parameters {

        enum Id: PathParameter {
            static let name = "accountId"
            static let description = "User account identifier"
            static let schema: Schema.Type = Schemas.Id.self
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
