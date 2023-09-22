//
//  ProjectAPIService.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class APIProject :Identifiable,Decodable, Hashable {
    
    static func == (lhs: APIProject, rhs: APIProject) -> Bool {
        lhs._id == rhs._id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(_id)
       }
    
    var _id : String
    var additional_attributes : AdditionalAttributes
    var name : String
    var description : String
    var sort_order : Int
    var id : String {
        return _id
    }
    
    init(){
        self.additional_attributes = AdditionalAttributes(createdBy: "", updatedBy: "", isDeleted: false, updatedAt: 0)
        self._id = ""
        self.name = ""
        self.description = ""
        self.sort_order = 0
    }

    init(additional_attributes: AdditionalAttributes, _id: String, name: String, description: String, sort_order: Int) {
        self.additional_attributes = additional_attributes
        self._id = _id
        self.name = name
        self.description = description
        self.sort_order = sort_order
    }

    func getTitle() -> String {
        name
    }

    func getUserId() -> String {
        additional_attributes.created_by
    }

    func getOrder() -> Int {
        sort_order
    }
    
    func getId() -> String {
        id
    }
}
