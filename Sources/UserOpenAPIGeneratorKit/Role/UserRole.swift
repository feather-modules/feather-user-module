import FeatherOpenAPIKit

extension User {
    public enum Role: Component {
        static let path: Path = User.path / "roles"
    }
}
