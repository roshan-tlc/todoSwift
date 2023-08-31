//
//  TodoRowView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct TodoRowView: View {
    @State var todo: Todo;
    @EnvironmentObject var todoView: TodoList

    var body: some View {
        HStack {
            CheckBox(isChecked: $todo.isCompleted, todo: todo)
                    .frame(width: 20, height: 20)
                    .padding(.leading, 30)
                    .padding(5)


            Text(todo.getTitle())
                .foregroundColor(todo.getStatus().rawValue == 1 ? Color.gray : Color.black)
                    .padding(.leading, 5)
                    .frame(width: 240, height: 20)

            Image(systemName: "minus.circle.fill")
                    .onTapGesture(perform: remove)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 30)
                    .padding(5)

        }
                .font(.title2)
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
