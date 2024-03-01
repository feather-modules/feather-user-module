import FeatherOpenAPIKit

extension User.Register {

    enum PathItems {

        enum Main: PathItem {
            static let path: Path = User.Register.path
            static let post: Operation.Type? = Operations.Post.self
        }
    }
}
