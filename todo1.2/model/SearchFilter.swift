//
//  searchFilter.swift
//  todo1.2
//
//  Created by Krithik Roshan on 24/08/23.
//

import Foundation

class SearchFilter : ObservableObject {
    
    var attribute:String = ""
    var status:Status = Status.ALL
    var isSearchEnable:Bool = false
    var parentId:String = ""
    var skip:Int = 0
    var limit:Limit = Limit.FIVE
    
    enum Status {
        case ALL
        case COMPLETED
        case UNCOMPLETED
    }
    
    enum Limit : Int {
        case FIVE = 5
        case TEN = 10
        case FIFTEEN = 15
    }
    
    func setAttribute(attribute:String) {
        self.attribute = attribute
    }
    
    func setSelectedStatus(status: SearchFilter.Status) -> Void {
        self.status = status
    }

    func setParentId(parentId:String) {
        self.parentId = parentId
    }

    func getParentId() -> String {
        parentId
    }

    func setLimit(limit:SearchFilter.Limit) {
        self.limit = limit
    }

    func setSkip(skip:Int) {
        self.skip = skip
    }
    
    func getAttribute() -> String {
         attribute
    }
    
    func getSelectedStatus() -> Status {
         status
    }

    func getSelectedLimit() -> Int {
        limit.rawValue
    }

    func getSkip() -> Int {
        skip
    }
}
