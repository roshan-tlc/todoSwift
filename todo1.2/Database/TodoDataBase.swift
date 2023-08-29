//
// Created by Krithik Roshan on 29/08/23.
//

import Foundation


import SwiftUI
import SQLite

class TodoDataBase : ObservableObject {
    
    static let shared = TodoDataBase()
     
    private var db = InitDataBase().getDb()

    func createTable() {
        guard let db = db else { return }

        do {
            try db.run("CREATE TABLE IF NOT EXISTS Todos (id TEXT PRIMARY KEY, title TEXT, status BOOLEAN, parentId TEXT FOREIGN_KEY)")
        } catch {
            print("Error creating table: \(error)")
        }
    }

    func insert(todo: Todo) {
        guard let db = db else { return }

        do {
            let insert = "INSERT INTO Todos (id, title, status, parentId) VALUES (?, ?, ?, ?)"
            try db.run(insert, todo.id, todo.title, todo.isCompleted ? true : false, todo.parentId)
        } catch {
            print("Error inserting data: \(error)")
        }
    }

    func get() -> [Todo] {
        guard let db = db else { return [] }

        var todos: [Todo] = []
        
        do {
            for row in try db.prepare("SELECT * FROM Todos") {
                let id = row[0] as! String
                let title = row[1] as! String
                let status = row[2] as! Bool
                let parentId = row[3] as! String
                todos.append(Todo(id: id, title: title, isCompleted: status, parentId: parentId))
            }
        } catch {
            print("Error retrieving data: \(error)")
        }
        print(todos)
        return todos
    }
    
    func remove(id:String) {
        guard let db = db else { return }
        
        do {
            let remove = "DELETE FROM Todos WHERE ID = ?"
            try db.run(remove, id)
        } catch {
            print("Error received :\(error)")
        }
    }
}
