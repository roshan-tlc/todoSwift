//
//  ContentView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var listView: ProjectList
    @State private var showMenu : Bool = false
    @State var userId : String = "1"
    
    
    init() {
        UserTable.shared.createTable()
        ProjectTable.shared.createTable()
        TodoTable.shared.createTable()
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
                        } label : {
                            Image(systemName: showMenu ? "xmark" :"text.justify")
                                .renderingMode(.original)
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
            .environmentObject(ProjectList())
    }
}
