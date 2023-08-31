//
//  User.swift
//  todo1.2
//
//  Created by Krithik Roshan on 25/08/23.
//

import Foundation

class User : Identifiable {
    internal var id:Int64
    private var name:String
    private var description:String

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
         name
    }
    
    func setName(name:String) {
        self.name =  name
    }
    
    func getDescription() -> String {
         description
    }
    
    func setDescription(description:String) {
        self.description = description
    }

}
