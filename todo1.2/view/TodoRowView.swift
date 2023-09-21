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
    @State var fontSize : ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily : ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor : ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor
    @State var isToastVisible = false
    @State var toastMessage = ""
    @EnvironmentObject var todoView: TodoList
    
    var body: some View {
        HStack {
            
            CheckBox(isChecked: $todo.is_completed, todo: todo, token: token)
                .frame(width: 20, height: 20)
                .padding(.leading, 30)
            
            Text(todo.getTitle())
                .foregroundColor(todo.is_completed == true ? Color.gray : Color.black)
                .padding(.trailing, 95)
                .frame(width: 240, height: 20)
                .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
            
            Image(systemName: "minus.circle.fill")
                .onTapGesture(perform: remove)
                .frame(width: 20, height: 20)
                .padding(.trailing, 30)
            
            
        }
        .padding(.vertical, 10)
        .toast(isPresented: $isToastVisible, message: $toastMessage)
    }
    
    
    func remove() {
        TodoAPIService.shared.remove(id: todo.getId(), token: token) { result, error in
            TodoAPIService.shared.get(id: todo.getId(), token: token) { result in
                print(result)
            }
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
            Image(systemName: isChecked == true ? Properties.checkmarkImage : Properties.squareImage)
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
