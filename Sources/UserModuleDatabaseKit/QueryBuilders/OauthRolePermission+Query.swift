import FeatherDatabase
import UserModuleKit

extension User.OauthRolePermission {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
