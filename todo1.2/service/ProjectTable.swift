//
// Created by Krithik Roshan on 29/08/23.
//

import Foundation


import SwiftUI
import SQLite

class ProjectTable : ObservableObject {
    
    static let shared = ProjectTable()

    private var db = InitDataBase.shared.getDb()
    
    private init() {
        
    }

    func createTable() {
        guard let db = db else { return }

        do {
            try db.run("DROP TABLE IF EXISTS Project")
            try db.run("CREATE TABLE IF NOT EXISTS Project (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, userId INTEGER, projectOrder INTEGER )")
        } catch {
            print("Error creating table: \(error)")
        }
    }

    func insert(project:Project) {
        guard let db = db else { return }

        do {
            let insert = "INSERT INTO Project (title, userId, projectOrder) VALUES ( ?, ?, ?)"
            try db.run(insert, project.getTitle(), project.getUserId(), project.getOrder())
        } catch {
            print("Error inserting data: \(error)")
        }
    }

    func get() -> [Project] {
        guard let db = db else { return [] }

        var projects: [Project] = []
        
        do {
            for row in try db.run("SELECT * FROM Project") {
                let id = row[0] as! Int64
                let title = row[1] as! String
                let userId = row[2] as! Int64
                let order = row [3] as! Int64
                projects.append(Project(id: id, title: title, userId: userId, order: Int(order)))
            }
        } catch {
            print("Error retrieving data: \(error)")
        }
        return projects
    }
    
    func get(id:Int64) -> [Project] {
        guard let db = db else { return [] }

        var projects: [Project] = []
        let query =  "SELECT id,title,userId,projectOrder FROM Project WHERE userId = ?"
        
        do {
            for row in try db.prepare(query, id) {
                let id = row[0] as! Int64
                let title = row[1] as! String
                let userId = row[2] as! Int64
                let order =  row[3] as! Int64
                projects.append(Project(id: id, title: title, userId: userId, order: Int(order)))
            }
        } catch {
            print("Error retrieving data: \(error)")
        }
        print(projects)
        return projects
    }
    
    func remove(id:Int64) {
        guard let db = db else { return }
        
        do {
            let remove = "DELETE FROM Project WHERE id = ?"
            try db.run(remove, id)
        } catch {
            print("Error received :\(error)")
        }
    }
}
