//
//  APIUser.swift
//  todo1.2
//
//  Created by Krithik Roshan on 21/09/23.
//

import Foundation

class APIUser : Decodable {
    
    var additional_attributes : UserAttributes
    var _id : String
    var name : String
    var title : String
    var email : String
    var id : String {
        return _id
    }
    
    init(){
        self.additional_attributes = UserAttributes(isDeleted: false, createdAt: 0, updatedAt: 0)
        self._id = ""
        self.name = ""
        self.title = ""
        self.email = ""
    }
    
    func getId() -> String{
        _id
    }

    func setId(id:Int64) {
        self.id = id
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
}
