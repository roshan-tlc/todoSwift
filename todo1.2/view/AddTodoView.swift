//
//  AddTodoView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 22/08/23.
//

import SwiftUI

struct AddTodoView: View {
    @State var textField:String = ""
    @EnvironmentObject var listView: TodoList
    @Environment(\.presentationMode) var presentationMode
    @State var parentId:String
    @State var searchText = ""
    @State var alertTitle : String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        
        TextField("Enter Your todo ", text: $textField)
            .frame( height: 50)
            .background(Color.mint)
        
        Button(
            action: addTodo
            , label: {
                Text("Add todo")
                    .font(.headline)
                    .frame(height: 50)
                    .background(Color.clear)

            })
        .alert(isPresented: $showAlert, content: getAlert)
        
    }
    func addTodo() {
        if textIsAppropriate() {
            listView.addTodo(title: textField, parentId: parentId)
            textField = ""
            
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textField.isEmpty {
            alertTitle = "Enter a valid todo"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
