//
//  User.swift
//  todo1.2
//
//  Created by Krithik Roshan on 25/08/23.
//

import Foundation

class User : Identifiable {
    var id:Int64
    var name:String
    var description:String

    init(id: Int64, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }

    func getId() -> Int64 {
        id
    }

    func setId(id:Int64) {
        self.id = id
    }

    func getName() -> String {
        return name
    }
    
    func setName(name:String) {
        self.name =  name
    }
    
    func getDescription() -> String {
        return description
    }
    
    func setDescription(description:String) {
        self.description = description
    }

}
