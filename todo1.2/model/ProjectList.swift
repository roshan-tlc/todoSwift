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
    var id:Int64  = 1
    
    func addProject(title:String, userId:String, order:SearchFilter.OrderType) {
       // projects.append(Project(id: String (id), title: title, userId: userId, order: order ))
        projectTable.insert(project: Project(id: id, title: title, userId: userId, order: order ))
        id += 1
    }
    
    func removeProject(id:Int64) {
//        if let index = projects.firstIndex(where: {$0.id == id}) {
//            projects.remove(at: index)
//        }
        projectTable.remove(id: id)
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
    
}
