//
//  ProjectAPIService.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class APITodo :Identifiable, Decodable {
    
    var additional_attributes : AdditionalAttributes
    var _id : String
    var name : String
    var description : String
    var sort_order : Int
    var is_completed : Bool
    var project_id : String
    var id : String {
        return _id
    }
    
    init(){
        self.additional_attributes = AdditionalAttributes(createdBy: "", updatedBy: "", isDeleted: false, createdAt: 0, updatedAt: 0)
        self._id = ""
        self.name = ""
        self.description = ""
        self.sort_order = 0
        self.is_completed = false
        self.project_id = "0"
    }
    
    init(additional_attributes: AdditionalAttributes, _id: String, name: String, description: String, sort_order: Int, is_completed:Bool, project_id: String) {
        self.additional_attributes = additional_attributes
        self._id = _id
        self.name = name
        self.description = description
        self.sort_order = sort_order
        self.is_completed = is_completed
        self.project_id = project_id
    }
    
    func getTitle() -> String {
        name
    }
    
    func getParentId() -> String {
        additional_attributes.created_by
    }
    
    func getOrder() -> Int {
        sort_order
    }
    
    func getId() -> String {
        id
    }
    
    func isCompleted() -> Bool {
        is_completed
    }
    
    func onCheckBoxClick() {
        is_completed.toggle()
    }
    
    
    enum TodoStatus: Int {
        case unCompleted = 0
        case completed  = 1
    }
}

