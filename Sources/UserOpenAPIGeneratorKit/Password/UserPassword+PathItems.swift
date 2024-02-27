import FeatherOpenAPIKit
import FeatherOpenAPIKitMacros

extension User.Password {

    enum PathItems {

        enum Set: PathItem {
            static let path: Path = User.Password.path
            static let post: Operation.Type? = Operations.Set.self
        }

        enum Reset: PathItem {
            static let path: Path = User.Password.path / "reset"
            static let post: Operation.Type? = Operations.Reset.self
        }
    }
}
