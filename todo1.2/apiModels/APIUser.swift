//
//  APIUser.swift
//  todo1.2
//
//  Created by Krithik Roshan on 21/09/23.
//

import Foundation

class APIUser : Decodable, Equatable {
    
    var additional_attributes : UserAttributes
    var _id : String
    var name : String
    var title : String
    var email : String
    var id : String {
        return _id
    }
    
    init()
    {
        self.additional_attributes = UserAttributes(isDeleted: false, createdAt: 0, updatedAt: 0)
        self._id = ""
        self.name = ""
        self.title = ""
        self.email = ""
    }
    
    init(additional_attributes: UserAttributes, _id: String, name: String, title: String, email: String) {
        self.additional_attributes = additional_attributes
        self._id = _id
        self.name = name
        self.title = title
        self.email = email
    }
    
    func getId() -> String{
        _id
    }

    func getEmail() -> String {
        email
    }

    func setEmail(email:String) {
        self.email = email
    }

    func getName() -> String {
         name
    }
    
    func setName(name:String) {
        self.name =  name
    }
    
    func getTitle() -> String {
         title
    }
    
    func setTitle(title:String) {
        self.title = title
    }

    static func ==(lhs: APIUser, rhs: APIUser) -> Bool {
        lhs.id == rhs.id
    }
}

struct UserAttributes : Decodable {

    var is_deleted : Bool
    var created_at : Int64
    var updated_at : Int64

    init(isDeleted: Bool, createdAt: Int64, updatedAt: Int64) {
        self.is_deleted = isDeleted
        self.created_at = createdAt
        self.updated_at = updatedAt
    }
    init() {
        self.is_deleted = false
        self.created_at = 0
        self.updated_at = 0
    }
}
