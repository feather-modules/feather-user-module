import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Account {

    enum PathItems {

        enum Me: PathItem {
            static let path: Path = User.Account.path / "me"
            static let get: Operation.Type? = Operations.Me.self
        }

        enum Main: PathItem {
            static let path: Path = User.Account.path
            static let get: Operation.Type? = Operations.List.self
            static let post: Operation.Type? = Operations.Create.self
            static let delete: Operation.Type? = Operations.BulkDelete.self
        }

        enum Identified: PathItem {
            static let path: Path = Main.path / Parameters.Id.path
            static let parameters: [Parameter.Type] = [
                Parameters.Id.self
            ]
            static let get: Operation.Type? = Operations.Detail.self
            static let put: Operation.Type? = Operations.Update.self
            static let patch: Operation.Type? = Operations.Patch.self
        }
    }
}
