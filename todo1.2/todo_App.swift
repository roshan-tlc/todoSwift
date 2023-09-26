//
//  todo1_2App.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

@main
struct todo_App: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(ProjectList.shared)
                .environmentObject(TodoList.shared)
        }
    }
}
