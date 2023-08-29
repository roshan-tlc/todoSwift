//
// Created by Krithik Roshan on 29/08/23.
//

import Foundation


import SwiftUI
import SQLite

class ProjectTable : ObservableObject {
    
    static let shared = ProjectTable()

    private var db = InitDataBase().getDb()

    func createTable() {
        guard let db = db else { return }

        do {
            try db.run("DROP TABLE Project")
            try db.run("CREATE TABLE IF NOT EXISTS Project (id TEXT PRIMARY KEY, title TEXT, userId TEXT )")
        } catch {
            print("Error creating table: \(error)")
        }
    }

    func insert(project:Project) {
        guard let db = db else { return }

        do {
            let insert = "INSERT INTO Project (id, title, userId) VALUES (?, ?, ?)"
            try db.run(insert, project.id, project.title, project.userId)
        } catch {
            print("Error inserting data: \(error)")
        }
    }

    func get() -> [Project] {
        guard let db = db else { return [] }

        var projects: [Project] = []
        
        do {
            for row in try db.prepare("SELECT * FROM Project") {
                let id = row[0] as! String
                let title = row[1] as! String
                let userId = row[2] as! String
                projects.append(Project(id: id, title: title, userId: userId, order: SearchFilter.OrderType.DSC))
            }
        } catch {
            print("Error retrieving data: \(error)")
        }

        print(projects)
        return projects
    }
    
    func remove(id:String) {
        guard let db = db else { return }
        
        do {
            let remove = "DELETE FROM Project WHERE ID = ?"
            try db.run(remove, id)
        } catch {
            print("Error received :\(error)")
        }
    }
}
