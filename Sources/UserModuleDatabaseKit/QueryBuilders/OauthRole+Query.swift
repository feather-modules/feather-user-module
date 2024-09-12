import FeatherDatabase
import UserModuleKit

extension User.OauthRole {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
