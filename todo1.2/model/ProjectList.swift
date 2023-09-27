//
//  ListViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class ProjectList : ObservableObject {
    @Published var projects :[APIProject] = []
    var apiProjects = [APIProject]()
    private let projectTable = ProjectTable.shared
    private var id:Int64  = 1
    private let apiService = ProjectAPIService.shared
    static let shared = ProjectList()
    
    private init() {}
    
    func addProject(title:String, userId:String) {
        projects.append(APIProject(additional_attributes: AdditionalAttributes(createdBy: userId, updatedBy: userId, isDeleted: false, updatedAt: 0), _id: String(id), name: title, description: title, sort_order: getOrder()))
        print(projects)
    }
    
    func get(id:String , token:String)  {
        apiService.get(id:id, token: token) { result in
            switch result {
            case .success(let project):
                project
            case .failure(_):
                self.apiProjects = []
            }
        }
    }
    
    func getOrder() -> Int {
        projects.count + 1
    }

    func getAll(token:String) {
        apiService.getAllProjects(token: token) { result in
            switch result {
            case .success(let project):
                DispatchQueue.main.async {
                    self.apiProjects = project.sorted(by: { $0.sort_order > $1.sort_order})
                    for project in project {
                        print(project.sort_order)
                    }
                    self.projects = self.apiProjects
                }
            case .failure(_):
                self.apiProjects = []
            }
        }
    }

    func remove(id:String) {
        projects.removeAll { $0.id == id}
    }
    
}
