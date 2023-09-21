//
//  TodoViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class TodoList: ObservableObject {
    @Published var todos = [Todo]()
    var apiTodos = [APITodo]()
    var todo = APITodo()
    static let shared = TodoList()
    private let filter = Filter()
    private let todoTable = TodoTable.shared
    private var parentId:String = "0"
    var id: Int64 = 1

    private init() {}

    func addTodo(title: String, parentId: String) throws {
        do {
            try todoTable.insert(todo: Todo(id: String(id), title: title, isCompleted: Todo.TodoStatus.unCompleted, parentId: parentId, order: getOrder()))
            self.parentId = parentId
            try todos = todoTable.get(parentId: parentId)
            id += 1
        } catch {
            throw error
        }
    }

    func removeTodo(id: String, userId: String) throws {
        do {
            try todoTable.remove(id: id)
            try todos = todoTable.get(parentId: userId)
        } catch {
            throw error
        }
    }

    func onCheckBoxClick(todo: APITodo, id:String, parentId:String, token:String )  {
        TodoAPIService.shared.update(id: id, isCompleted: todo.is_completed, token: token, projectId: parentId)  { result, error in
            if let error = error {
                print("error")
            }
            
        }
    }

    func getTodos(status: SearchFilter.Status, parentId: String, token:String)-> [APITodo] {
        TodoAPIService.shared.getAllProjects(token: token) { result in
            switch result {
            case .success(let todo):
                self.apiTodos = todo
            case .failure(_):
                self.apiTodos = []
            }
        }
        return apiTodos
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
    
    func get(id:String, token:String) -> APITodo {
        
        TodoAPIService.shared.get(id: id, token: token) { result in
            switch result {
            case .success (let todo) :
                self.todo = todo
                print("success", todo)
            case .failure(_):
                self.todo = APITodo()
            }
        }
        return todo
    }
    
}
