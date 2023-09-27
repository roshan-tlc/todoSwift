//
//  ProjectAPIService.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class APITodo : Identifiable, Decodable, Hashable, Encodable, Comparable {
    
    static func < (lhs: APITodo, rhs: APITodo) -> Bool {
        lhs.sort_order < rhs.sort_order
    }
    
    
    static func == (lhs: APITodo, rhs: APITodo) -> Bool {
        lhs._id == rhs._id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(_id)
    }
    
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
        self.additional_attributes = AdditionalAttributes(createdBy: "", updatedBy: "", isDeleted: false, updatedAt: 0)
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
        project_id
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
    
    func getStatus() -> Bool {
        is_completed
    }
    
    enum TodoStatus: Int {
        case unCompleted = 0
        case completed  = 1
    }

    func encode(to encoder: Encoder) throws {

    }
}

struct AdditionalAttributes : Decodable {
    var created_by : String
    var updated_by : String
    var is_deleted : Bool
    var updated_at : Int64

    init(createdBy: String, updatedBy: String, isDeleted: Bool, updatedAt: Int64) {
        self.created_by = createdBy
        self.updated_by = updatedBy
        self.is_deleted = isDeleted
        self.updated_at = updatedAt
    }

    init() {
        self.created_by = ""
        self.updated_by = ""
        self.is_deleted = false
        self.updated_at = 0
    }
}

