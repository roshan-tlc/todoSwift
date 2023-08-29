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
    let userId : String
    let order: SearchFilter.OrderType
    
    init(id:String, title:String, userId:String, order:SearchFilter.OrderType) {
        self.id = id
        self.title = title
        self.userId = userId
        self.order = order
    }
    
    func getId() -> String {
        return id
    }
    
    func getTitle() -> String {
        return title
    }
    
}
