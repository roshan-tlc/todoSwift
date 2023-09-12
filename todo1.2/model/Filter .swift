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
    
    func setSearchFilter(searchItem:SearchFilter) throws {
        do {
            Filter.searchFilterResult = try TodoList.shared.getSearchFilteredTodo(searchItem: searchItem)
        } catch {
            throw error
        }
    }

    func getSearchFilter() -> [Todo] {
        let filteredSequence = Filter.searchFilterResult
        return Array(filteredSequence)
    }
}
