//
//  Todo.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation
import SQLite

class Todo : Identifiable {
    internal let id : String
    private let title : String
    internal var isCompleted : TodoStatus
    private var parentId : String
    private var order: Int64
    
    init(id:String, title:String, isCompleted: TodoStatus, parentId:String, order:Int64) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.parentId = parentId
        self.order = order
    }
    
    func getId() -> String {
        id
    }

    func getTitle() -> String {
        title
    }
    
    func onCheckBoxClick() {
        switch isCompleted {
        case .completed:
            isCompleted = .unCompleted
        case .unCompleted:
            isCompleted = .completed
        }
    }

    func setParentId(parentId : String) {
        self.parentId = parentId
    }

    func getParentId() -> String {
        parentId
    }

    func getStatus() -> TodoStatus {
        isCompleted
    }
    
    func getOrder() -> Int64 {
         order
    }
    
    func setOrder(order:Int64) {
        self.order = order
    }
    
    static func > (lsh:Todo, rhs:Todo) -> Bool {
        lsh.id > rhs.id
    }
    
    enum TodoStatus: Int {
        case unCompleted = 0
        case completed  = 1
    }

}
