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
       
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                }
                
                GeometryReader{ _ in
                    HStack {
                        MenuView(userId: userId)
                            .offset(x:showMenu ? 0 : UIScreen.main.bounds.width)
                    }
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button {
                            self.showMenu.toggle()
                            listView.projects = ProjectTable.shared.get(id: userId)
                            ThemeTable.shared.get()
                        } label : {
                            Image(systemName: showMenu ? "xmark" :"text.justify")
                                .renderingMode(.original)
                        }
                        .foregroundColor(defaultColor.color)
                    }
                }
                
                VStack {
                   
                    NavigationLink(destination: Theme()) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                                .renderingMode(.original)
                                .foregroundColor(defaultColor.color)
                                .frame(alignment: .topTrailing)
                        }
                    }
                    Spacer()
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
