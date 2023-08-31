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
            try db.run("CREATE TABLE IF NOT EXISTS Todos (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, status BOOLEAN, parentId TEXT FOREIGN_KEY)")
        } catch {
            print("Error creating table: \(error)")
        }
    }

    func insert(todo: Todo) {
        guard let db = db else { return }

        do {
            let insert = "INSERT INTO Todos ( title, status, parentId) VALUES ( ?, ?, ?)"
            try db.run(insert, todo.title, todo.isCompleted ? true : false, todo.parentId)
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

    func get(parentId:String) -> [Todo] {
        guard let db = db else { return [] }

        var todos: [Todo] = []
        
        do {
            let query = "SELECT * FROM Todos WHERE parentId = ?"
            for row in try db.prepare(query, parentId) {
                if let id = row[0] as? Int64,
                   let title = row[1] as? String,
                   let parentId = row[3] as? String {
                    todos.append(Todo(id: id, title: title, isCompleted: false, parentId: parentId))
                } else {
                    print("Error converting values for row: \(row)")
                }
            }
        } catch {
            print("Error retrieving data: \(error)")
        }
        
        print(todos)
        return todos
    }
    
    func searchFilter(searchFilter:SearchFilter) -> [Todo] {
        guard let db = db else {return []}
        
        var todos: [Todo] = []
        let query = "SELECT * FROM TODO WHERE parentID = ? AND title = ? LIMIT = ? OFFSET = ?"
        
        do {
            for row in try db.run(query, searchFilter.getParentId(), searchFilter.getAttribute(),searchFilter.getSelectedLimit(), searchFilter.getSkip()) {
                if let id = row[0] as? Int64,
                   let title = row[1] as? String,
                   let parentId = row[3] as? String {
                    todos.append(Todo(id: id, title: title, isCompleted: false, parentId: parentId))
                } else {
                    print("Error converting values for row: \(row)")
                }
            }
                    
            
        }
    }
    
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
