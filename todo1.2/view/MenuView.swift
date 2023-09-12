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
    @State var isAddViewVisible = false
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    @State var toastMessage = ""
    @State var isToastVisible = false
    @State var returnToMenu = false

    var body: some View {
        VStack {
            HStack {
                Text("Menu")
                        .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
            }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
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
                            .multilineTextAlignment(.center)
                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))

                    Button(
                            action: addProject
                            , label: {
                        Text("Add Project")
                                .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                                .frame(width: 150, height: 50)
                                .foregroundColor(.black)
                                .background(.secondary).opacity(0.5)
                                .multilineTextAlignment(.center)
                                .cornerRadius(10)
                    })
                            .alert(isPresented: $showAlert, content: getAlert)
                }
            }
            List {
                ForEach(listView.projects) { item in
                    NavigationLink(destination: AppView(project: item, showProject: true, userId: userId)) {
                        ListRowView(project: item)
                    }
                            .onAppear {
                                do {
                                    TodoList.shared.todos = try TodoTable.shared.get(parentId: item.id)
                                } catch {
                                    toastMessage = "\(error)"
                                    isToastVisible.toggle()
                                }
                            }
                }
                        .onMove(perform: moveTodo)
            }
            Spacer()
        }
                .frame(width: 280)
                .padding(.top, 50)
                .border(Color.black, width: 0.2)
                .edgesIgnoringSafeArea(.vertical)
                .background(ApplicationTheme.shared.defaultColor.color)
    }

    func moveTodo(from source: IndexSet, to destination: Int) {
        listView.projects.move(fromOffsets: source, toOffset: destination)
        do {
            try ProjectTable.shared.updateProjectTable()
        } catch {
            toastMessage = "\(error)"
            isToastVisible.toggle()
        }
    }

    func addProject() {
        if textIsAppropriate() {
            do {
                try listView.addProject(title: textField, userId: userId, order: listView.getOrder())
            } catch {
                toastMessage = "\(error)"
                isToastVisible.toggle()
            }
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




