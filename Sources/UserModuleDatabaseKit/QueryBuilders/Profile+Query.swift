import FeatherDatabase
import UserModuleKit

extension User.Profile {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}

