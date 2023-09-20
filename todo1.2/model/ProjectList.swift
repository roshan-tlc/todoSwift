//
//  ListViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class ProjectList : ObservableObject {
    @Published var projects :[Project] = []
    private let projectTable = ProjectTable.shared
    private var id:Int64  = 1
    static let shared = ProjectList()

    private init() {}

    func addProject(title:String, userId:Int64, order:Int, token:String) throws {
        do {
            try projectTable.insert(project: Project(id: id, title: title, userId: userId, order: order))
            projects = try projectTable.get(id: userId)
            print(projects)
            id += 1
        } catch {
            throw error
        }
    }

    func removeProject(id:Int64, userId:Int64) throws {
        do {
            try projectTable.remove(id: id)
            projects = try projectTable.get(id: userId)
        } catch {
            throw error
        }
    }

    func getLastId() -> Int64 {
        id
    }

    func get() throws ->[Project]  {
        do {
            return try projectTable.get()
        } catch {
            throw error
        }
    }

    func get(id:Int64) throws -> [Project] {
        do {
            return try projectTable.get(id: id)
        } catch {
            throw error
        }
    }

    func getOrder() -> Int {
         projects.count + 1
    }

}
