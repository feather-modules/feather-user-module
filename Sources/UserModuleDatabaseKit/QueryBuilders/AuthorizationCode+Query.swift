import FeatherDatabase
import UserModuleKit

extension User.AuthorizationCode {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
