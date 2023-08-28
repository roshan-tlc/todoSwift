//
//  Project.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

struct Project : Identifiable{
    let id : String
    let title : String
    
    init(id:String, title:String) {
        self.id = id
        self.title = title
    }
    
    func getId() -> String {
        return id
    }
    
    func getTitle() -> String {
        return title
    }
    
}
