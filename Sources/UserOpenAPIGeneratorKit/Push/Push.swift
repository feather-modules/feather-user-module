import FeatherOpenAPIKit

extension User {
    public enum Push: Component {
        static let path: Path = User.path / "push"
    }
}
