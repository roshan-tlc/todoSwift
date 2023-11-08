//
//  Filter .swift
//  todo1.2
//
//  Created by Krithik Roshan on 23/08/23.
//

import Foundation

class Filter : ObservableObject {

    static var searchFilterResult = [APITodo]()
    var limit:SearchFilter.Limit = SearchFilter.Limit.FIVE
    var skip:Int = 0
    
    func setSearchFilter(searchItem:SearchFilter, todos:[APITodo]) throws {
            Filter.searchFilterResult = getSearchFilteredTodo(searchItem: searchItem, todos:todos)
    }

    func getSearchFilter() -> [APITodo] {
        let filteredSequence = Filter.searchFilterResult
        return Array(filteredSequence)
    }

    func getSearchFilteredTodo(searchItem: SearchFilter, todos:[APITodo]) -> [APITodo] {

        var filteredTodos = [APITodo]()
        filteredTodos = todos.filter { $0.name.lowercased().contains(searchItem.attribute.lowercased())}

        if searchItem.status == SearchFilter.Status.COMPLETED {
            filteredTodos = filteredTodos.filter {
                $0.getStatus() == true
            }
        } else if searchItem.status == SearchFilter.Status.UNCOMPLETED {
            filteredTodos = filteredTodos.filter {
                $0.getStatus() == false
            }
        }
        return filteredTodos
    }
}
