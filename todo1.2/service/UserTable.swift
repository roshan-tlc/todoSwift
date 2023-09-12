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

    func createTable() throws {
        guard let db = db else { return }

        do {
           // try db.run("drop table User")
            try db.run("CREATE TABLE IF NOT EXISTS User (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, email TEXT)")
        } catch {
            throw error
        }
    }

    func insert(user:User) throws {
        guard let db = db else { return }

        let insert = "INSERT INTO User ( name, description, email) VALUES (?, ?, ?)"

        do {
            try db.run(insert, user.getName(), user.getDescription(), user.getEmail())
        } catch {
            throw error
        }
    }

    func getId(email:String) throws -> Int64 {
        guard let db = db else { return 0 }

        let query = "SELECT id FROM User WHERE email = ?"

        do {
           for row in try db.run(query, email){
               return row[0] as! Int64
           }

        } catch{
            throw error
        }
        return 0
    }
    
    func update(id:Int64, name:String, description:String, email:String ) throws {
        guard let db =  db else { return }
        
        let update = "UPDATE User SET name = ? , description = ?, email = ?  WHERE id = ?"
        
        do {
            try db.run(update, name, description, email, id)
        } catch {
            throw error
        }
    }


    func get() throws  -> [User] {
        guard let db = db else { return [] }

        var users: [User] = []

        do {
            for row in try db.prepare("SELECT id, name, description, email FROM User") {
                let id = row[0] as! Int64
                let name = row[1] as! String
                let description = row[2] as! String
                let email = row[3] as! String
                users.append(User(id: id, name: name, description: description, email: email))
            }
        } catch {
            throw error
        }

        return users
    }
    
    func get(id:Int64) throws -> User {
        guard let db = db else { return User(id: 0, name: "", description: "", email: "")}
        let query = "SELECT id, name, description, email FROM User WHERE id = ?"
        
        do {
            for row in try db.prepare(query,id) {
                let id = row[0] as! Int64
                let name = row[1] as! String
                let description = row[2] as! String
                let email = row[3] as! String
                return User(id: id, name: name, description: description, email: email)
            }
        } catch {
            throw error
        }
        
        return User(id: 0, name: "", description: "", email: "")
    }

    func get(email:String) throws -> User {
        guard let db = db else { return User(id: 0, name: "", description: "", email: "")}
        let query = "SELECT id, name, description, email FROM User WHERE email = ?"

        do {
            for row in try db.prepare(query,email) {
                let id = row[0] as! Int64
                let name = row[1] as! String
                let description = row[2] as! String
                let email = row[3] as! String
                return User(id: id, name: name, description: description, email: email)
            }
        } catch {
            throw error
        }

        return User(id: 0, name: "", description: "", email: "")
    }
    
    func remove(id:Int64) throws {
        guard let db = db else { return }
        
        do {
            let remove = "DELETE FROM User WHERE id = ?"
            try db.run(remove, id)
        } catch {
            throw error
        }
    }
}
