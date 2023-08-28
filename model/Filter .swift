//
//  Filter .swift
//  todo1.2
//
//  Created by Krithik Roshan on 23/08/23.
//

import Foundation

class Filter : ObservableObject {
    
    static var searchFilterResult = [Todo]()
    
    func setSearchFilter(searchItem:SearchFilter, type:SearchFilter.OrderType) {
        Filter.searchFilterResult = TodoList().getSearchFilteredTodo(searchItem: searchItem, type: type)
    }
    
    func getSearchFilter() -> [Todo] {
        print(Filter.searchFilterResult)
        return Filter.searchFilterResult
    }

}


