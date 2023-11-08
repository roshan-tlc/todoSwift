//
//  ContentView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct AppView: View {

    @EnvironmentObject var listView: ProjectList
    @EnvironmentObject var todoList: TodoList
    @State var message = ""
    @State var isToastVisible = false
    @State var project: APIProject?
    @State var showProject = false
    @State private var showMenu: Bool = false
    @State var userId: String
    @State var token:String
    @State var user = APIUser()
    
    init(project:APIProject, showProject: Bool, userId:String, token:String){
        self.project = project
        self.showProject = showProject
        self.userId = userId
        self.token = token
    }

    var body: some View {

        ZStack {
            ApplicationTheme.shared.defaultColor.color
                .ignoresSafeArea()
            VStack {
                Spacer()

                if showProject == true {
                    if let project = project {
                        TodoView(projectId: project.getId(), title: project.getTitle(), token: token)
                    }
                }
            }

            GeometryReader { geometry in
                HStack {
                    MenuView(userId: userId, token: token, user: user)
                            .offset(x: showMenu ? 0 : UIScreen.main.bounds.width)
                }
            }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                DispatchQueue.main.async {
                                    ProjectList.shared.getAll(token: token)
                                    todoList.getAll(token: token)
                                    UserList.shared.setUser(token: token)
                                }
                                self.showMenu.toggle()
                            } label: {
                                Image(systemName: showMenu ? IconProperties.xMarkImage : IconProperties.textJustifyImage)
                                        .renderingMode(.original)
                            }
                                    .foregroundColor(Color.primary)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {

                            NavigationLink(destination: Theme(token: token)) {
                                Text(Properties.settings)
                                        .foregroundColor(.primary)
                            }
                        }
                    }
        }
                .navigationBarBackButtonHidden(true)//
                .toast(isPresented: $isToastVisible, message: $message)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
                .environmentObject(ProjectList.shared)
    }
}
