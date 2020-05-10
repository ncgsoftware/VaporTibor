import Vapor
import Fluent

final class UserModel: Model {
    
    static let schema = "user_users"
    
    struct FieldKeys {
        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
    }
    
    //Mark: -fields
    
    @ID() var id: UUID?
    @Field(key: FieldKeys.email) var email: String
    @Field(key: FieldKeys.password) var password: String

    public init(id: UserModel.IDValue? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
    
    init() {}
    
}

extension UserModel: Authenticatable {}

extension UserModel: SessionAuthenticatable {
    typealias SessionID = UUID

    var sessionID: SessionID { self.id! }
}
