import FeatherDatabase
import UserModuleKit

extension User.Group {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
