import FeatherOpenAPIKit

extension User {
    public enum Register: Component {
        static let path: Path = User.path / "register"
    }
}
