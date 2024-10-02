import FeatherDatabase
import UserModuleKit

extension User.AccountGroup {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
