//
//  MenuView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct MenuView: View {

    @State var textField: String = ""
    @State var userId: Int64
    @EnvironmentObject var listView: ProjectList
    @Environment(\.presentationMode) var presentationMode
    @State var isAddViewVisible = false
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    @State var returnToMenu = false

    var body: some View {
        VStack {
            HStack {
                Text("Menu")
                        .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))

            }
                    .padding(.vertical, 40)
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
                            .frame(width: 250, height: 50)
                            .background(Color.cyan)
                            .cornerRadius(10)
                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))

                    Button(
                            action: addProject
                            , label: {
                        Text("Add Project")
                                .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                                .frame(height: 50)
                                .foregroundColor(.black)
                    })
                            .alert(isPresented: $showAlert, content: getAlert)
                }
            }
            List {
                ForEach(listView.projects) { item in
                    NavigationLink(destination: TodoView(project: item)) {
                        ListRowView(project: item)
                    }
                            .onAppear {
                                TodoList.shared.todos = TodoTable.shared.get(parentId: item.id)
                            }
                }
                        .onMove(perform: moveTodo)

            }

            Spacer()

        }
                .frame(width: 300)
                .padding(.top, 50)
                .border(Color.black, width: 0.2)
                .edgesIgnoringSafeArea(.vertical)
                .background(ApplicationTheme.shared.defaultColor.color)
    }

    func moveTodo(from source: IndexSet, to destination: Int) {
        listView.projects.move(fromOffsets: source, toOffset: destination)
        ProjectTable.shared.updateProjectTable()
    }

    func addProject() {
        if textIsAppropriate() {
            listView.addProject(title: textField, userId: userId, order: listView.getOrder())
            textField = ""
            presentationMode.wrappedValue.dismiss()
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
        Alert(title: Text(alertTitle))
    }
}


struct CustomBackButton<Content: View>: View {
    @Binding var isActive: Bool
    var content: Content

    init(isActive: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isActive = isActive
        self.content = content()
    }

    var body: some View {
        Button(action: {
            self.isActive = false
        }) {
            Image(systemName: "arrow.left.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title)
            content
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
                    .environmentObject(ProjectList.shared)
        }
    }
}


