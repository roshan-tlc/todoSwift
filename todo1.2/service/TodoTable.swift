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

    func createTable() {
        guard let db = db else { return }

        do {
            try db.run("drop table Todos")
            try db.run("CREATE TABLE IF NOT EXISTS Todos (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, status INTEGER, parentId INTEGER FOREIGN_KEY)")
        } catch {
            print("Error creating table: \(error)")
        }
    }

    func insert(todo: Todo) {
        guard let db = db else { return }

        do {
            let insert = "INSERT INTO Todos ( title, status, parentId) VALUES ( ?, ?, ?)"
            try db.run(insert, todo.getTitle(), todo.getStatus().rawValue, todo.getParentId())
        } catch {
            print("Error inserting data: \(error)")
        }
    }
    
    func onCheckBoxChange(id:Int64) {
        guard let db = db else {return }

        let query = "UPDATE Todos SET status = NOT status WHERE id = ?"
        
        do {
            try db.run(query,id)
        } catch {
            print("Error inserting data: \(error)")
        }

    }

    func get(parentId: Int64) -> [Todo] {
        guard let db = db else { return [] }
        var todos: [Todo] = []
        
        let query = "SELECT id, title, status, parentId FROM Todos WHERE parentId = ?"
        
        do {
            let statement = try db.prepare(query)
            let rows = try statement.run(parentId)
            
            for row in rows {
                if let id = row[0] as? Int64,
                   let title = row[1] as? String,
                   let statusInt = row[2] as? Int64,
                   let parentId = row[3] as? Int64,
                   let taskStatus = Todo.TodoStatus(rawValue: Int(statusInt)) {
                    
                    let task = Todo(id: id, title: title, isCompleted: taskStatus, parentId: parentId)
                    todos.append(task)
                } else {
                    print("Invalid row data: \(row)")
                }
            }
        } catch {
            print("Error retrieving data: \(error)")
        }
        
        return todos
    }


//    
//    func searchFilter(searchFilter:SearchFilter) -> [Todo] {
//        guard let db = db else {return []}
//        
//        var todos: [Todo] = []
//        let query = "SELECT * FROM Todos WHERE  title LIKE ? AND parentID = ? "
//        
//        do {
//            for row in try db.run(query, searchFilter.getParentId(), searchFilter.getAttribute()) {
//                if let id = row[0] as? Int64,
//                   let title = row[1] as? String,
//                   let parentId = row[3] as? Int64 {
//                    todos.append(Todo(id: id, title: title, isCompleted: false, parentId: parentId))
//                } else {
//                    print("Error converting values for row: \(row)")
//                }
//            }
//        } catch {
//            print("Error retrieving data: \(error)")
//        }
//        
//        return todos
//    }
    
    func remove(id:Int64) {
        guard let db = db else { return }
        
        do {
            let remove = "DELETE FROM Todos WHERE id = ?"
            try db.run(remove, id)
        } catch {
            print("Error received :\(error)")
        }
    }
}
