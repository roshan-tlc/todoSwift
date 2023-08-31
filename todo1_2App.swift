//
//  todo1_2App.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

@main
struct todo1_2App: App {
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(ProjectList())
                .environmentObject(TodoList())
        }
    }
}
