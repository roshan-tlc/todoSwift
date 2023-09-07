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
            //try db.run("drop table User")
            try db.run("CREATE TABLE IF NOT EXISTS User (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, email TEXT)")
        } catch {
            print("Error on creating table user : \(error)")
        }
    }

    func insert(user:User) {
        guard let db = db else { return }

        let insert = "INSERT INTO User ( name, description, email) VALUES (?, ?, ?)"

        do {
            try db.run(insert, user.getName(), user.getDescription(), user.getEmail())
        } catch {
            print("Error on inserting data in user table : \(error)")
        }
    }

    func getId(email:String) -> Int64 {
        guard let db = db else { return 0 }

        let query = "SELECT id FROM User WHERE email = ?"

        do {
           for row in try db.run(query, email){
               return row[0] as! Int64
           }

        } catch{
            print("Error on getting user id from User table \(error)")
        }
        return 0
    }
    
    func update(id:Int64, name:String, description:String, email:String ) {
        guard let db =  db else { return }
        
        let update = "UPDATE User SET name = ? , description = ?, email = ?  WHERE id = ?"
        
        do {
            try db.run(update, name, description, email, id)
        } catch {
            print("Error in update data in user tabel : \(error)")
        }
    }


    func get() -> [User] {
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
            print("Error retrieving data on get all user in user table : \(error)")
        }

        return users
    }
    
    func get(id:Int64) -> User {
        guard let db = db else { return User(id: 1, name: "", description: "", email: "")}
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
            print("Error retrieving data get user in user table : \(error)")
        }
        
        return User(id: 1, name: "", description: "", email: "")
    }
    
    func remove(id:Int64) {
        guard let db = db else { return }
        
        do {
            let remove = "DELETE FROM User WHERE id = ?"
            try db.run(remove, id)
        } catch {
            print("Error received on remove user from user table  :\(error)")
        }
    }
}
