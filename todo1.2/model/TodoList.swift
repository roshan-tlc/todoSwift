//
//  TodoViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class TodoList: ObservableObject {
    static var todos = [Todo]()
    private var filter = Filter()
    var id = 1

    func removeTodo(id: String) {
        if let index = TodoList.todos.firstIndex(where: { $0.id == id }) {
            TodoList.todos.remove(at: index)
        }
        TodoDataBase.shared.remove(id: id)
    }

    func addTodo(title: String, parentId: String) {
        TodoList.todos.append(Todo(id: String(id), title: title, isCompleted: false, parentId: parentId))
        TodoDataBase.shared.insert(todo: Todo(id: String(id), title: title, isCompleted: false, parentId: parentId))
        //print(TodoList.todos)
        id += 1
    }

    func onCheckBoxClick(todo: Todo) {
        if let index = TodoList.todos.firstIndex(where: { $0.id == todo.id }) {
            TodoList.todos[index] = todo
        }
    }

    func getTodos(status: SearchFilter.Status, parentId: String) -> [Todo] {
        var filteredData = [Todo]()

        for todo in TodoDataBase.shared.get() {
            if todo.parentId == parentId {
                if (status == SearchFilter.Status.COMPLETED) {
                    if (todo.isCompleted == true) {
                        filteredData.append(todo)
                    }
                } else if (status == SearchFilter.Status.UNCOMPLETED) {
                    if (todo.isCompleted == false) {
                        filteredData.append(todo)
                    }
                } else {
                    filteredData.append(todo)
                }
            }
        }
        return filteredData.sorted { $0 > $1}
    }

    func getSearchFilteredTodo(searchItem: SearchFilter, type: SearchFilter.OrderType) -> [Todo] {
        print(searchItem.attribute)
        print(TodoList.todos)
        let searchedTodos = TodoList.todos.filter {
            $0.title.lowercased().contains(searchItem.attribute.lowercased())
        }
        var filteredTodos = [Todo]()

        if searchItem.status == SearchFilter.Status.COMPLETED {
            filteredTodos = searchedTodos.filter {
                $0.isCompleted == true
            }
        } else if searchItem.status == SearchFilter.Status.UNCOMPLETED {
            filteredTodos = searchedTodos.filter {
                $0.isCompleted == false
            }
        } else {
            filteredTodos = searchedTodos
        }

        if searchItem.type == SearchFilter.OrderType.DSC {
            return filteredTodos.sorted {
                $0 > $1
            }
        }
        return filteredTodos
    }
}

