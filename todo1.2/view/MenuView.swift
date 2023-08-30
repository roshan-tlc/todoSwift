//
//  MenuView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct MenuView: View {
    
    @State var textField:String = ""
    @State var userId:String = "2"
    @EnvironmentObject var listView: ProjectList
    @Environment(\.presentationMode) var presentationMode
    @State var isAddViewVisible = false
    @State var projects:[Project] = ProjectList().get(id: "2")
    @State var alertTitle : String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("Menu")
                    .font(.title)
                    .foregroundColor(.black)
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
                    
            }
            if isAddViewVisible {
                VStack {
                    TextField("Enter Your Project", text: $textField)
                        .frame(width: 250 , height: 50)
                        .background(Color.cyan)
                        .cornerRadius(10)
                    
                    Button(
                        action: addProject
                        , label: {
                            Text("Add Project")
                                .font(.headline)
                                .frame(height: 50)
                                .background(Color.clear)
                        })
                    .alert(isPresented: $showAlert, content: getAlert)
                }
            }
            List {
                ForEach(projects) { item in
                    NavigationLink(destination: TodoView(project: item)) {
                        ListRowView(project: item)
                    }
                }
                .onMove(perform: moveTodo)
            }

            
            Spacer()
            
        }.frame(width: 300)
            .edgesIgnoringSafeArea(.trailing)
            .foregroundColor(Color.black)
                .background(Color.secondary)
            .navigationBarBackButtonHidden(true)
    }
    
    func moveTodo(from source: IndexSet, to destination: Int) {
        projects.move(fromOffsets: source, toOffset: destination)
        
        
    }
    
    func addProject() {
        if textIsAppropriate() {
            userId = listView.getLastId()
            listView.addProject(title: textField, userId: userId, order: SearchFilter.OrderType.DSC)
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
        return Alert(title: Text(alertTitle))
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppView()
                .environmentObject(ProjectList())
        }
    }
}


