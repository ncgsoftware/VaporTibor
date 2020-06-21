//
//  File.swift
//  
//
//  Created by Jeremy Nelson on 6/13/20.
//

import Vapor
import Fluent
import ContentApi

final class UserTokenModel: Model {
    static let schema = "user_tokens"
    
    struct FieldKeys {
        static var value: FieldKey { "value" }
        static var userId: FieldKey { "user_id" }
    }
    
    @ID() var id: UUID?
    @Field(key: FieldKeys.value) var value: String
    @Parent(key: FieldKeys.userId) var user: UserModel
    
    init() {}
    
    init(id: UserTokenModel.IDValue? = nil, value: String, userId: UserModel.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userId
    }
}

extension UserTokenModel: GetContentRepresentable {
    struct GetContent: Content {
        var id: String
        var value: String
        
        init(model: UserTokenModel){
            self.id = model.id!.uuidString
            self.value = model.value
        }
    }
    
    var getContent: GetContent { .init(model: self)}
}

extension UserTokenModel: ModelTokenAuthenticatable {
    static let valueKey = \UserTokenModel.$value
    static let userKey = \UserTokenModel.$user
    
    var isValid: Bool { true }
}
