//
//  Project.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

struct Project : Identifiable{
    internal let id : Int64
    private let title : String
    private let userId : Int64
    private let order: Int
    
    init(id:Int64, title:String, userId:Int64, order:Int) {
        self.id = id
        self.title = title
        self.userId = userId
        self.order = order
    }
    
    func getId() -> Int64 {
        id
    }
    
    func getTitle() -> String {
        title
    }

//    func setUserId(userId: Int64) {
//        userId = userId
//    }

    func getUserId() -> Int64 {
        userId
    }
    
    func getOrder() -> Int {
        order
    }
}
