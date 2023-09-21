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
    @State var toastMessage = ""
    @State var isToastVisible = false
    @State var alertTitle : String = ""
    @State var showAlert: Bool = false
    @State var token:String
    
    var body: some View {
        VStack {
            TextField(Properties.enterTodo, text: $textField)
                    .frame(height: 50)
                    .background(ApplicationTheme.shared.defaultColor.color).opacity(0.8)
                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))

            Button(
                    action: addTodo
                    , label: {
                Text(Properties.addTodo)
                        .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                        .frame(height: 50)
                        .foregroundColor(ApplicationTheme.shared.defaultColor.color)
            })
                    .alert(isPresented: $showAlert, content: getAlert)
                    .toast(isPresented: $isToastVisible, message: $toastMessage)
        }

    }
    func addTodo() {
        if textIsAppropriate()  {
            TodoAPIService.shared.create(name: textField, description: Properties.description, token: token, projectId: parentId) { result , error in
                if let error = error {
                    toastMessage = "\(error)"
                    isToastVisible.toggle()
                } else if result == true {
                    toastMessage = Properties.todoCreatedSuccess
                    isToastVisible.toggle()
                } else {
                    toastMessage = Properties.todoCreatedUnsuccess
                    isToastVisible.toggle()
                }
                
            }
            textField = ""
            
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textField.isEmpty {
            alertTitle = Properties.enterTodo
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        Alert(title: Text(alertTitle))
    }
    
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
