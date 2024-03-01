import FeatherOpenAPIKit

extension User.Auth {

    enum PathItems {

        enum Main: PathItem {
            static let path: Path = User.Auth.path
            static let post: Operation.Type? = Operations.Post.self
            static let delete: Operation.Type? = Operations.Delete.self
        }
    }
}
