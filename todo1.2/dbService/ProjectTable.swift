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

    func createTable() throws  {
        guard let db = db else { return }

        do {
            //try db.run(Properties.dropProjectTable)
            try db.run(DBProperties.createProjectTable)
        } catch {
            throw error
        }
    }

    func insert(project:Project) throws {
        guard let db = db else { return }

        do {
            let insert = DBProperties.insertProjectTable
            try db.run(insert, project.getTitle(), project.getUserId(), project.getOrder())
        } catch {
            throw error
        }
    }

    func get() throws -> [Project] {
        guard let db = db else { return [] }

        var projects: [Project] = []

        do {
            for row in try db.run(DBProperties.getAllProject) {
                let id = row[0] as! Int64
                let title = row[1] as! String
                let userId = row[2] as! Int64
                let order = row [3] as! Int64
                projects.append(Project(id: id, title: title, userId: userId, order: Int(order)))
            }
        } catch {
            throw error
        }
        return projects
    }

    func get(id:String) throws -> [Project] {
        guard let db = db else { return [] }

        var projects: [Project] = []
        let query = DBProperties.getProjects

        do {
            for row in try db.prepare(query, id) {
                let id = row[0] as! Int64
                let title = row[1] as! String
                let userId = row[2] as! Int64
                let order =  row[3] as! Int64
                projects.append(Project(id: id, title: title, userId: userId, order: Int(order)))
            }
        } catch {
            throw error
        }

        return projects
    }


    func updateProjectTable() throws  {
        guard let db = db else { return}
        do {
            let projectTable = Table(DBProperties.projectTable)
            let idColumn = Expression<Int64>(DBProperties.id)
            let orderColumn = Expression<Int>(DBProperties.projectOrder)

            try db.transaction {
                for (index, project) in ProjectList.shared.projects.enumerated() {
                    let projectToUpdate = projectTable.filter(idColumn == project.id)
                    try db.run(projectToUpdate.update(orderColumn <- index))
                }
            }
        } catch {
            throw error
        }
    }

    func remove(id:Int64) throws {
        guard let db = db else { return }

        do {
            let remove = DBProperties.removeProject
            try db.run(remove, id)
        } catch {
            throw error
        }
    }
}
