//
//  TodoViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class TodoList: ObservableObject {
    @Published var todos = [Todo]()
    static let shared = TodoList()
    private let filter = Filter()
    private let todoTable = TodoTable.shared
    private var parentId:Int64 = 0
    var id: Int64 = 1

    private init() {}

    func addTodo(title: String, parentId: Int64) {
        todoTable.insert(todo: Todo(id: id, title: title, isCompleted: Todo.TodoStatus.unCompleted, parentId: parentId, order: getOrder()))
        self.parentId = parentId
        todos = todoTable.get(parentId: parentId)
        id += 1
    }
    
    func removeTodo(id: Int64, userId: Int64) {
        todoTable.remove(id: id)
        todos = todoTable.get(parentId: id)
    }

    func onCheckBoxClick(todo: Todo) {
        todoTable.onCheckBoxChange(id: todo.getId())
        todos = todoTable.get(parentId: todo.getParentId())
    }

    func getTodos(status: SearchFilter.Status, parentId: Int64) -> [Todo] {
        var filteredData = [Todo]()

        for todo in todoTable.get(parentId: parentId) {
            if (status == SearchFilter.Status.COMPLETED) {
                if (todo.getStatus().rawValue == 1) {
                    filteredData.append(todo)
                }
            } else if (status == SearchFilter.Status.UNCOMPLETED) {
                if (todo.getStatus().rawValue == 0) {
                    filteredData.append(todo)
                }
            } else {
                filteredData.append(todo)
            }
        }
        
        return filteredData.sorted {
            $0 > $1
        }
    }
    
    func moveItem(from source:Int, to destination:Int ) {
        guard source != destination else  { return }
        guard source > 5 else { return }
        let moveItem = todos.remove(at: source)
        todos.insert(moveItem, at: destination)
        todoTable.updateTodoTable()
       // todos = todoTable.get(parentId: parentId)
    }
    
    func getOrder() -> Int64 {
        Int64(todos.count + 1)
    }

    func getSearchFilteredTodo(searchItem: SearchFilter) -> [Todo] {

        let searchedTodos = todoTable.get(parentId: searchItem.parentId).filter {
            $0.getTitle().lowercased().contains(searchItem.attribute.lowercased())
        }
        var filteredTodos = [Todo]()

        if searchItem.status == SearchFilter.Status.COMPLETED {
            filteredTodos = searchedTodos.filter {
                $0.getStatus().rawValue == 1
            }
        } else if searchItem.status == SearchFilter.Status.UNCOMPLETED {
            filteredTodos = searchedTodos.filter {
                $0.getStatus().rawValue == 0
            }
        } else {
            filteredTodos = searchedTodos
        }

        return filteredTodos.sorted {
            $0 > $1
        }
        //return todoTable.searchFilter(searchFilter: searchItem)
    }
}
