//
//  Filter .swift
//  todo1.2
//
//  Created by Krithik Roshan on 23/08/23.
//

import Foundation

class Filter : ObservableObject {

    static var searchFilterResult = [Todo]()
    var limit:SearchFilter.Limit = SearchFilter.Limit.FIVE
    var skip:Int = 0
    
    func setSearchFilter(searchItem:SearchFilter) {
        Filter.searchFilterResult = TodoList.shared.getSearchFilteredTodo(searchItem: searchItem)
    }

    func getSearchFilter() -> [Todo] {
        print("search filter out")
        print(Filter.searchFilterResult)

        let filteredSequence = Filter.searchFilterResult
        return Array(filteredSequence)
    }
}
