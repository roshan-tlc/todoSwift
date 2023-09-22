//
//  TodoViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class TodoList: ObservableObject {
    @Published var todos = [APITodo]()
    var apiTodos = [APITodo]()
    var todo = APITodo()
    static let shared = TodoList()
    private let filter = Filter()
    private let todoTable = TodoTable.shared
    private var parentId: String = "0"
    var id: Int64 = 1

    private init() {
    }

    func addTodo(title: String, parentId: String) {
        todos.append(APITodo(additional_attributes: AdditionalAttributes(), _id: String(1), name: title, description: "", sort_order: getOrder(), is_completed: false, project_id: parentId))
    }

    func removeTodo(id: String, userId: String) {
        todos.removeAll {
            $0.id == id
        }
    }

    func onCheckBoxClick(todo: APITodo, id: String, parentId: String, token: String) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            let matchingTodo = todos[index]
            matchingTodo.onCheckBoxClick()
            todos[index] = matchingTodo
        }

        TodoAPIService.shared.update(id: id, isCompleted: todo.is_completed, token: token, projectId: parentId) { result, error in
            if let error = error {
                print("error")
            }

        }
    }

    func getAll(token: String, completion: @escaping ([APITodo]) -> Void) {
        TodoAPIService.shared.getAll(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todo):
                    self.apiTodos = todo
                    completion(todo)
                case .failure(_):
                    self.apiTodos = []
                    completion([])
                }
            }
        }
    }

    func getTodos(status: SearchFilter.Status, parentId: String) -> [APITodo] {
        var filteredTodos = [APITodo]()
        for todo in todos {
            if todo.getParentId() == parentId {
                if status == SearchFilter.Status.COMPLETED {
                    filteredTodos = todos.filter {
                        $0.getStatus() == true
                    }
                } else if status == SearchFilter.Status.UNCOMPLETED {
                    filteredTodos = todos.filter {
                        $0.getStatus() == false
                    }
                } else {
                    filteredTodos.append(todo)
                }
            }
        }
        return filteredTodos
    }

    func getOrder() -> Int {
        todos.count + 1
    }

    func getSearchFilteredTodo(searchItem: SearchFilter) -> [APITodo] {

        var filteredTodos = [APITodo]()

        filteredTodos = todos.filter {
            $0.name == searchItem.attribute
        }

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

    func get(id: String, token: String) -> APITodo {

        TodoAPIService.shared.get(id: id, token: token) { result in
            switch result {
            case .success(let todo):
                self.todo = todo
                print("success", todo)
            case .failure(_):
                self.todo = APITodo()
            }
        }
        return todo
    }

}
