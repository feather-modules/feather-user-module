import FeatherDatabase
import UserModuleKit

extension User.AccountInvitationType {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
