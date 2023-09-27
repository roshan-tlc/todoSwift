//
//  todo1_2App.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

@main
struct todoApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(ProjectList.shared)
                .environmentObject(TodoList.shared)
                .environmentObject(Filter())
                .environmentObject(ApplicationTheme.shared)
                .environmentObject(SearchFilter())
                .environmentObject(UserList())
        }
    }
}
