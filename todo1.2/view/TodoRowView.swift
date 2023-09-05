//
//  TodoRowView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct TodoRowView: View {
    @State var todo: Todo;
    @State var fontSize : ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily : ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor : ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor
    @EnvironmentObject var todoView: TodoList

    var body: some View {
        HStack {
            CheckBox(isChecked: $todo.isCompleted, todo: todo)
                    .frame(width: 20, height: 20)
                    .padding(.leading, 30)
                    //.padding()


            Text(todo.getTitle())
                    .foregroundColor(todo.getStatus().rawValue == 1 ? Color.gray : Color.black)
                    .padding(.trailing, 95)
                    .frame(width: 240, height: 20)
                    .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))

            Image(systemName: "minus.circle.fill")
                    .onTapGesture(perform: remove)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 30)


        }
            .padding(.vertical, 10)
    }

    func remove() {
        todoView.removeTodo(id: todo.id,userId: todo.getParentId() )
    }
}

struct CheckBox: View {
    @Binding var isChecked: Todo.TodoStatus
    @State var todo: Todo
    @EnvironmentObject var todoView: TodoList

    var body: some View {
        VStack {
            Image(systemName: isChecked.rawValue == 1 ? "checkmark.square" : "square")
                    .onTapGesture {
                        todo.onCheckBoxClick()
                        todoView.onCheckBoxClick(todo: todo)
                    }
        }

    }
}


struct TodoRowView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
