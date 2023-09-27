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
    @State var fontSize: CGFloat = ApplicationTheme.shared.fontSize
    @State var fontFamily: ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor: Color = ApplicationTheme.shared.defaultColor
    @State var message = ""
    @State var isToastVisible = false
    @State var project: APIProject?
    @State var showProject = false
    @State private var showMenu: Bool = false
    @State var userId: String
    @State var token:String
    
    init(project:APIProject, showProject: Bool, userId:String, token:String){
        self.project = project
        self.showProject = showProject
        self.userId = userId
        self.token = token
    }

    var body: some View {

        ZStack {

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
                    MenuView(userId: userId, token: token)
                            .offset(x: showMenu ? 0 : UIScreen.main.bounds.width)
                }
            }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                ProjectList.shared.getAll(token: token)
                                todoList.getAll(token: token)

                                self.showMenu.toggle()
                            } label: {
                                Image(systemName: showMenu ? Properties.xMarkImage : Properties.textJustifyImage)
                                        .renderingMode(.original)
                            }
                                    .foregroundColor(Color.primary)

                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {

                            NavigationLink(destination: LoginView()) {
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
