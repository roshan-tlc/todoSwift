//
//  ContentView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var listView: ProjectList
    @State var fontSize : ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily : ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor : ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor
    @State private var showMenu : Bool = false
    @State var userId : Int64 = 1
    
    
    init() {
        UserTable.shared.createTable()
        ProjectTable.shared.createTable()
        TodoTable.shared.createTable()
        ThemeTable.shared.createTable()

        if ThemeTable.shared.getFirstId() == 0 {
            ThemeTable.shared.insert(theme: ApplicationTheme.shared)
        }
        ApplicationTheme.shared.defaultColor = ThemeTable.shared.getColor()
        ApplicationTheme.shared.fontSize = ThemeTable.shared.getFontSize()
        ApplicationTheme.shared.fontFamily = ThemeTable.shared.getFontFamily()
       
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                ApplicationTheme.shared.defaultColor.color
                        .ignoresSafeArea()
                VStack {
                    Spacer()
                }

                GeometryReader { geometry  in
                    HStack {
                        MenuView(userId: userId)
                                .offset(x: showMenu ? 0 : UIScreen.main.bounds.width)
                    }
                }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    self.showMenu.toggle()
                                    listView.projects = ProjectTable.shared.get(id: userId)


                                } label: {
                                    Image(systemName: showMenu ? "xmark" : "text.justify")
                                            .renderingMode(.original)
                                }
                                        .foregroundColor(Color.primary)

                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {

                                NavigationLink(destination: Theme() ) {
                                    Text("Settings")
                                            .foregroundColor(.primary)
                                }
                            }
                        }
            }
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(ProjectList.shared)
    }
}
