import FeatherOpenAPIKit

extension User.Account {

    public enum Parameters {

        public enum Id: PathParameter {
            public static let name = "accountId"
            public static let description = "User account identifier"
            public static let schema: Schema.Type = Schemas.Id.self
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
