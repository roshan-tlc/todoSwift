//
//  ListViewModel.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import Foundation

class ProjectList : ObservableObject {
    @Published var projects :[Project] = []
    var id = 1
    
    func addProject(title:String, userId:String, order:SearchFilter.OrderType) {
        projects.append(Project(id: String (id), title: title, userId: userId, order: order ))
        ProjectTable.shared.insert(project: Project(id: String (id), title: title, userId: userId, order: order ))
        id += 1
    }
    
    func removeProject(id:String) {
        if let index = projects.firstIndex(where: {$0.id == id}) {
            projects.remove(at: index)
        }
        ProjectTable.shared.remove(id: id)
    }
    
    func getLastId() -> String {
        String(id)
    }
    
}
