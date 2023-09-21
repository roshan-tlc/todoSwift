//
//  ListViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class ProjectList : ObservableObject {
    @Published var projects :[Project] = []
    var apiProjects = [APIProject]()
    private let projectTable = ProjectTable.shared
    private var id:Int64  = 1
    private let apiService = ProjectAPIService.shared
    static let shared = ProjectList()

    private init() {}

    func addProject(title:String, userId:Int64, order:Int, token:String) throws {
        do {
            try projectTable.insert(project: Project(id: id, title: title, userId: userId, order: order))
            projects = try projectTable.get(id: String(userId))
            print(projects)
            id += 1
        } catch {
            throw error
        }
    }


    func getLastId() -> Int64 {
        id
    }

    func get(id:String , token:String)  {
        apiService.get(id:id, token: token) { result in
            switch result {
            case .success(let project):
                print(project)
            case .failure(_):
                self.apiProjects = []
            }
        }
    }

    func getOrder() -> Int {
         projects.count + 1
    }
    
    func getAll(token:String) -> [APIProject]{
        apiService.getAllProjects(token: token) { result in
            switch result {
            case .success(let project):
                self.apiProjects = project
            case .failure(_):
                self.apiProjects = []
            }
        }
        return apiProjects
    }

}
