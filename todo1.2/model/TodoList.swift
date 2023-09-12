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

    func addTodo(title: String, parentId: Int64) throws {
        do {
            try todoTable.insert(todo: Todo(id: id, title: title, isCompleted: Todo.TodoStatus.unCompleted, parentId: parentId, order: getOrder()))
            self.parentId = parentId
            try todos = todoTable.get(parentId: parentId)
            id += 1
        } catch {
            throw error
        }
    }
    
    func removeTodo(id: Int64, userId: Int64) throws {
        do {
            try todoTable.remove(id: id)
            try todos = todoTable.get(parentId: id)
        } catch {
            throw error
        }
    }

    func onCheckBoxClick(todo: Todo) throws {
        do {
            try todoTable.onCheckBoxChange(id: todo.getId())
            try todos = todoTable.get(parentId: todo.getParentId())
        } catch {
            throw error
        }
    }

    func getTodos(status: SearchFilter.Status, parentId: Int64) throws -> [Todo] {
        var filteredData = [Todo]()
        do {
            for todo in try todoTable.get(parentId: parentId) {
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
            return filteredData
        } catch {
            throw error
        }
    }

    func getOrder() -> Int64 {
        Int64(todos.count + 1)
    }

    func getSearchFilteredTodo(searchItem: SearchFilter) throws -> [Todo] {
        do {
            let searchedTodos = try todoTable.get(parentId: searchItem.parentId).filter {
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
            return filteredTodos
        } catch {
            throw  error
        }
    }
}
