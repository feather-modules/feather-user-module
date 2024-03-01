import FeatherOpenAPIKit

extension User {
    public enum Account: Component {
        static let path: Path = User.path / "accounts"
    }
}
