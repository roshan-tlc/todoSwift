//
//  ContentView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct AppView: View {

    @EnvironmentObject var listView: ProjectList
    @State var fontSize: ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily: ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor: ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor
    @State var message = ""
    @State var isToastVisible = false
    @State var project: APIProject?
    @State var showProject = false
    @State private var showMenu: Bool = false
    @State var userId: Int64
    @State var token:String

    var body: some View {

        ZStack {
            ApplicationTheme.shared.defaultColor.color
                    .ignoresSafeArea()
            VStack {
                Spacer()

                if showProject == true {
                    //TodoView(project: project ?? APIProject(additional_attributes: AdditionalAttributes(createdBy: "", updatedBy: "", isDeleted: false, createdAt: 0, updatedAt: 0), id: "", name: "", description: "", sortedOrder: 0))
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
                                self.showMenu.toggle()
                                do {
                                    try listView.projects = ProjectTable.shared.get(id: userId)
                                } catch {
                                    message = Properties.errorOccurred + " \(error)"
                                    isToastVisible.toggle()
                                }

                            } label: {
                                Image(systemName: showMenu ? Properties.xMarkImage : Properties.textJustifyImage)
                                        .renderingMode(.original)
                            }
                                    .foregroundColor(Color.primary)

                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {

                            NavigationLink(destination: Theme()) {
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
