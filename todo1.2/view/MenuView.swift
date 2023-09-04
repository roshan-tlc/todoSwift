//
//  MenuView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct MenuView: View {
    
    @State var textField:String = ""
    @State var userId:Int64 
    @EnvironmentObject var listView: ProjectList
    @Environment(\.presentationMode) var presentationMode
    var fontSize : CGFloat = ApplicationTheme.shared.fontSize.rawValue
    var fontFamily : String = ApplicationTheme.shared.fontFamily.rawValue
    @State var isAddViewVisible = false
    var themeColor : Color = ApplicationTheme.shared.getDefaultColor()
    @State var alertTitle : String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Menu")
                    .foregroundColor(themeColor)
                    .font(Font.custom(fontFamily, size: fontSize))
                
                NavigationLink(destination: Theme()) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                            .renderingMode(.original)
                            .frame(alignment: .leading)
                            .padding()
                    }
                }
            }
            VStack {
                UserView(id: userId)
            }
            VStack {

                Image(systemName: "plus.app")
                    .renderingMode(.original)
                    .onTapGesture {
                        isAddViewVisible.toggle()
                        
                    }
                    .frame(width: 80, height: 50)
                    .imageScale(.large)
                    .frame(alignment: .leading)
                    .foregroundColor(themeColor)
                    
            }
            if isAddViewVisible {
                VStack {
                    TextField("Enter Your Project", text: $textField)
                        .frame(width: 250 , height: 50)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .font(Font.custom(fontFamily, size: fontSize))
                    
                    Button(
                        action: addProject
                        , label: {
                            Text("Add Project")
                                .font(Font.custom(fontFamily, size : fontSize))
                                .frame(height: 50)
                                .background(Color.clear)
                        })
                    .alert(isPresented: $showAlert, content: getAlert)
                }
            }
            List {
                ForEach(listView.projects) { item in
                    NavigationLink(destination: TodoView(project: item)) {
                        ListRowView(project: item)
                    }
                }
                .onMove(perform: moveTodo)
                .foregroundColor(themeColor)
            }
            
            Spacer()
            
        }.frame(width: 300)
            .edgesIgnoringSafeArea(.trailing)
            .foregroundColor(Color.black)
                .background(Color.secondary)
            .navigationBarBackButtonHidden(true)
    }
    
    func moveTodo(from source: IndexSet, to destination: Int) {
        
        listView.projects.move(fromOffsets: source, toOffset: destination)
        ProjectTable.shared.updateProjectTable()
       // listView.projects = ProjectTable.shared.get(id: userId)
    }
    
    func addProject() {
        if textIsAppropriate() {
            listView.addProject(title: textField, userId:userId, order: listView.getOrder())
            textField = ""
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textField.isEmpty {
            alertTitle = "Enter a valid todo1.2"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        Alert(title: Text(alertTitle))
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppView()
                .environmentObject(ProjectList.shared)
        }
    }
}


