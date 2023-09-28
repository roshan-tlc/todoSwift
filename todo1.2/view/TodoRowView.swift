//
//  TodoRowView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct TodoRowView: View {
    
    @State var todo: APITodo;
    @State var token:String
    @Binding var todos: [APITodo]
    @State var isToastVisible = false
    @State var toastMessage = ""
    @EnvironmentObject var todoView: TodoList
    
    var body: some View {
        HStack {
            CheckBox(isChecked: $todo.is_completed, todo: todo, token: token)
                .frame(width: 20, height: 20)
                .padding(.leading, 30)
            
            Text(todo.getTitle())
                .foregroundColor(todo.is_completed == true ? .secondary : .primary)
                .padding(.trailing, 95)
                .frame(width: 240, height: 20)
                .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
            
            Image(systemName: IconProperties.minusCircleImage)
                .onTapGesture(perform: remove)
                .frame(width: 20, height: 20)
                .padding(.trailing, 30)
                    .foregroundColor(.primary)
            
            
        }
        .padding(.vertical, 10)
        .toast(isPresented: $isToastVisible, message: $toastMessage)
    }
    
    
    func remove() {
        todoView.removeTodo(id: todo.getId())
        TodoAPIService.shared.remove(id: todo.getId(), token: token) { result, error in
            
            if let error = error  {
                toastMessage = "\(error)"
                isToastVisible.toggle()
            } else if result == true {
                toastMessage = Properties.projectRemoveSuccess
                isToastVisible.toggle()
            } else {
                toastMessage = Properties.projectRemoveUnSuccess
                isToastVisible.toggle()
            }
        }
    }
}

struct CheckBox: View {
    
    @Binding var isChecked: Bool
    @State var todo: APITodo
    @EnvironmentObject var todoView: TodoList
    @State var isToastVisible = false
    @State var toastMessage = ""
    @State var token:String
    
    var body: some View {
        VStack {
            Image(systemName: isChecked == true ? IconProperties.checkmarkImage : IconProperties.squareImage)
                    .foregroundColor(.primary)
                .onTapGesture {
                    isChecked.toggle()
                    todo.onCheckBoxClick()
                    todoView.onCheckBoxClick(todo: todo, id:todo.getId(),  parentId:todo.getParentId(), token: token)
                }
        }
    }
}


struct TodoRowView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
