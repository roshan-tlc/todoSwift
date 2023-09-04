//
// Created by Krithik Roshan on 29/08/23.
//

import Foundation


import SwiftUI
import SQLite

class UserTable : ObservableObject {
    
    static let shared = UserTable()

    private var db = InitDataBase.shared.getDb()
    
    private init() {
        
    }

    func createTable() {
        guard let db = db else { return }

        do {
            try db.run("CREATE TABLE IF NOT EXISTS User (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)")
        } catch {
            print("Error creating table: \(error)")
        }
    }

    func insert(user:User) {
        guard let db = db else { return }

        do {
            let insert = "INSERT INTO User ( name, description) VALUES (?, ?)"
            try db.run(insert, user.getName(), user.getDescription())
        } catch {
            print("Error inserting data: \(error)")
        }
    }
    
    func update(id:Int64, name:String, description:String) {
        guard let db =  db else { return }
        
        let update = "UPDATE User SET name = ? , description = ? WHERE id = ?"
        
        do {
            try db.run(update, name, description, id)
        } catch {
            print("Error in update data: \(error)")
        }
    }

    func get() -> [User] {
        guard let db = db else { return [] }

        var users: [User] = []

        do {
            for row in try db.prepare("SELECT id, name, description FROM User") {
                let id = row[0] as! Int64
                let name = row[1] as! String
                let description = row[2] as! String
                users.append(User(id: id, name: name, description: description))
            }
        } catch {
            print("Error retrieving data: \(error)")
        }

        return users
    }
    
    func get(id:Int64) -> User {
        guard let db = db else { return User(id: 1, name: "", description: "")}
        let query = "SELECT * FROM User WHERE id = ?"
        
        do {
            for row in try db.prepare(query,id) {
                let id = row[0] as! Int64
                let name = row[1] as! String
                let description = row[2] as! String
                return User(id: id, name: name, description: description)
            }
        } catch {
            print("Error retrieving data: \(error)")
        }
        
        return User(id: 1, name: "", description: "")
    }
    
    func remove(id:String) {
        guard let db = db else { return }
        
        do {
            let remove = "DELETE FROM User WHERE id = ?"
            try db.run(remove, id)
        } catch {
            print("Error received :\(error)")
        }
    }
}
