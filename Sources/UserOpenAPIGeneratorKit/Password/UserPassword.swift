import FeatherOpenAPIKit

extension User {
    public enum Password: Component {
        static let path: Path = User.path / "password"
    }
}
