//
//  ProjectAPIService.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

struct APIProject :Identifiable,Decodable {
    //var id: Int64 = 1
    var id : String
    var additional_attributes : AdditionalAttributes
    var name : String
    var description : String
    var sort_order : Int

    init(additional_attributes: AdditionalAttributes, id: String, name: String, description: String, sortedOrder: Int) {
        self.additional_attributes = additional_attributes
        self.id = id
        self.name = name
        self.description = description
        self.sort_order = sortedOrder
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
}
