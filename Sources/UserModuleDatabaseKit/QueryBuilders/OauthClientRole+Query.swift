import FeatherDatabase
import UserModuleKit

extension User.OauthClientRole {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
