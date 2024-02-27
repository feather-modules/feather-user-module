import FeatherOpenAPIKit

extension User {
    public enum Auth: Component {
        static let path: Path = User.path / "auth"
    }
}
