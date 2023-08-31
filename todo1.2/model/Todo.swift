//
//  Todo.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation
import SQLite

class Todo : Identifiable {
    let id : Int64
    let title : String
    var isCompleted : Bool
    let parentId : String
    
    init(id:Int64, title:String, isCompleted:Bool, parentId:String) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.parentId = parentId
    }
    
    func getId() -> Int64 {
        return id
    }
    
    func onCheckBoxClick() {
        self.isCompleted.toggle()
    }
    
    static func > (lsh:Todo, rhs:Todo) -> Bool {
        return lsh.id > rhs.id
    }
    
    enum todoStatus : Int {
        case completed = 0
        case unCompleted  = 1
    }
}
