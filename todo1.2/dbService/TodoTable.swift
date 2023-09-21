//
// Created by Krithik Roshan on 29/08/23.
//

import Foundation

import SwiftUI
import SQLite

class TodoTable : ObservableObject {

    static let shared = TodoTable()

    private var db = InitDataBase.shared.getDb()

    private init() {

    }

    func createTable() throws {
        guard let db = db else { return }

        do {
            //try db.run(Properties.dropTodoTable)
            try db.run(DBProperties.createTodoTable)
        } catch {
            throw error
        }
    }

    func insert(todo: Todo) throws {
        guard let db = db else { return }
        do {
            let insert = DBProperties.insertTodos
            try db.run(insert, todo.getTitle(), todo.getStatus().rawValue, todo.getParentId(), todo.getOrder())
        } catch {
            throw error
        }
    }

    func onCheckBoxChange(id:String) throws  {
        guard let db = db else {return }

        let query = DBProperties.updateCheckbox

        do {
            try db.run(query,id)
        } catch {
            throw error
        }

    }

    func get(parentId: String) throws -> [Todo] {
        guard let db = db else { return [] }
        var todos: [Todo] = []

        let query = DBProperties.getTodos

        do {
            let statement = try db.prepare(query)
            let rows = try statement.run(parentId)

            for row in rows {
                if let id = row[0] as? String,
                   let title = row[1] as? String,
                   let statusInt = row[2] as? Int64,
                   let order = row[4] as? Int64,
                   let parentId = row[3] as? String,
                   let taskStatus = Todo.TodoStatus(rawValue: Int(statusInt)) {

                    let task = Todo(id: id, title: title, isCompleted: taskStatus, parentId: parentId, order: order)
                    todos.append(task)
                } else {
                    throw InitDataBase.dbError.invalidData
                }
            }
        } catch {
            throw error
        }

        return todos
    }

    func updateTodoTable() throws {
        guard let db = db else { return}
        do {
            let projectTable = Table(DBProperties.todoTable)
            let idColumn = Expression<String>(DBProperties.id)
            let orderColumn = Expression<Int>(DBProperties.position)

            try db.transaction {
                for (index, todo) in TodoList.shared.todos.enumerated() {
                    let projectToUpdate = projectTable.filter(idColumn == todo.id)
                    try db.run(projectToUpdate.update(orderColumn <- index))
                }
            }
        } catch {
            throw error
        }
    }

    func remove(parentId:Int64) throws {
        guard let db = db else { return }

        do {
            let remove = DBProperties.removeTodos
            try db.run(remove, parentId)
        } catch {
            throw error
        }
    }

    func remove(id:String) throws {
        guard let db = db else { return }

        do {
            let remove = DBProperties.removeTodo
            try db.run(remove, id)
        } catch {
            throw error
        }
    }
}
