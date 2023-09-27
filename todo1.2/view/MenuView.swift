//
//  MenuView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct MenuView: View {

    @State var textField: String = ""
    @State var userId: String
    @EnvironmentObject var projectView: ProjectList
    @State var isAddViewVisible = false
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    @State var toastMessage = ""
    @State var isToastVisible = false
    @State var returnToMenu = false
    @State var token: String

    init(userId: String, token: String) {
        self.userId = userId
        self.token = token
    }

    var body: some View {
        VStack {
            HStack {
                Text(Properties.menu)
                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize))
            }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
            VStack {

                UserView(user: APIUser(), token: token)
            }
            VStack {

                Image(systemName: Properties.plusAppImage)
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
                    TextField(Properties.enterProject, text: $textField)
                            .frame(width: 250, height: 30)
                            .background(.secondary.opacity(0.5))

                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize))

                    Button(action: {
                        addProject(token: token)
                    }) {
                        Text(Properties.addProject)
                            .font(.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize))
                                .frame(width: 150, height: 30)
                                .foregroundColor(.black)
                                .background(Color.secondary.opacity(0.5))
                                .cornerRadius(10)
                    }
                            .alert(isPresented: $showAlert, content: getAlert)

                }
            }
            List {
                ForEach(projectView.projects, id: \.self) { item in
                    NavigationLink(destination: AppView(project: item, showProject: true, userId: userId, token: token)) {
                        ListRowView(project: item, token: token)
                    }
                }
                        .onMove(perform: moveProject)

            }
            Spacer()
        }
                .frame(width: 280)
                .padding(.top, 50)
                .border(Color.black, width: 0.2)
                .edgesIgnoringSafeArea(.vertical)
                .background(.white).ignoresSafeArea()
    }

    func moveProject(from source: IndexSet, to destination: Int) {

        guard destination >= 0, destination < projectView.projects.count else { return }
        projectView.projects.move(fromOffsets: source, toOffset: destination)
        let movedProject = projectView.projects[destination]

        for (position, item) in projectView.projects.enumerated() {
            let newOrder = position + 1
            let updateOrder:[String: Any] = ["sort_order": newOrder]
            print(item.getId(), item.sort_order)

            ProjectAPIService.shared.updatePosition(id: movedProject.getId(), token: token, updatedOrder: updateOrder)  {error in
                if let error = error {
                    print("error", error
                    )
                    toastMessage = "\(error)"
                    isToastVisible.toggle()
                } else {
                    toastMessage = Properties.updateSuccess
                    isToastVisible.toggle()
                }
            }
        }


    }


    func addProject(token: String) -> Void {
        if textIsAppropriate() {
            ProjectAPIService.shared.create(name: textField, description: "description", token: token) { result, error in
                if let error = error {
                    toastMessage = "\(error)\n" + Properties.projectCreatedUnSuccess
                    isToastVisible.toggle()
                } else if result == true {
                    toastMessage = Properties.projectCreatedSuccess

                    isToastVisible.toggle()
                } else {
                    toastMessage = Properties.projectCreatedUnSuccess
                    isToastVisible.toggle()
                }
            }
            projectView.addProject(title: textField, userId: userId)
            textField = ""
        }
    }

    func textIsAppropriate() -> Bool {
        if textField.isEmpty {
            alertTitle = Properties.enterValidProject
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
            LoginView()
                    .environmentObject(ProjectList.shared)
        }
    }
}




