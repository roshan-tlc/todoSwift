//
// Created by Krithik Roshan on 29/08/23.
//

import Foundation


import SwiftUI
import SQLite

class UserTable : ObservableObject {
    
    static let shared = UserTable()

    private var db = InitDataBase().getDb()

    func createTable() {
        guard let db = db else { return }

        do {
            try db.run("CREATE TABLE IF NOT EXISTS User (id TEXT PRIMARY KEY, name TEXT, descrptiption TEXT)")
        } catch {
            print("Error creating table: \(error)")
        }
    }

    func insert(user:User) {
        guard let db = db else { return }

        do {
            let insert = "INSERT INTO User (name, description) VALUES (?, ?)"
            try db.run(insert, user.name, user.description)
        } catch {
            print("Error inserting data: \(error)")
        }
    }

    func get(parentId:String) -> [User] {
        guard let db = db else { return [] }

        var users: [User] = []

        do {
            for row in try db.prepare("SELECT * FROM User") {
                let id = row[0] as! String
                let name = row[1] as! String
                let description = row[2] as! String
                users.append(User(id: id, name: name, description: description))
            }
        } catch {
            print("Error retrieving data: \(error)")
        }

        return users
    }
    
    func remove(id:String) {
        guard let db = db else { return }
        
        do {
            let remove = "DELETE FROM User WHERE ID = ?"
            try db.run(remove, id)
        } catch {
            print("Error received :\(error)")
        }
    }
}
