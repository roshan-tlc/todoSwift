//
//  ListViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class ProjectList : ObservableObject {
    @Published var projects :[Project] = ProjectTable.shared.get()
    private let projectTable = ProjectTable.shared
    private var id:Int64  = 1
    
    func addProject(title:String, userId:Int64, order:Int) {
        projectTable.insert(project: Project(id: id, title: title, userId: userId, order: order ))
        projects = projectTable.get(id: userId)
        print(projects)
        id += 1
    }
    
    func removeProject(id:Int64, userId:Int64) {
        projectTable.remove(id: id)
        projects = projectTable.get(id: userId)
    }
    
    func getLastId() -> Int64 {
        id
    }
    
    func get()->[Project] {
        projectTable.get()
    }
    
    func get(id:Int64) -> [Project]{
        projectTable.get(id: id)
    }

    func getOrder() -> Int {
         projects.count + 1
    }
    
}
