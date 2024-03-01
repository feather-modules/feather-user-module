import FeatherOpenAPIKit

extension User.Register {

    enum Schemas {

        enum Token: TextSchema {
            static let description = "The invitation token"
            static let examples = [
                "uuimnfzda8b35r2o1wnadx4hq3p46vzo02u5fx9vitgrmlgbgeasz5d3lvz7d8rq"
            ]
        }
    }
}
