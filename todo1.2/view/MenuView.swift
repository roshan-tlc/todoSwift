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
    @State var token:String
    var project:[APIProject]
    
    init(userId:String, token:String) {
        self.userId = userId
        self.token = token
        self.project = ProjectList.shared.getAll(token: token)
        
    }

    var body: some View {
        VStack {
            HStack {
                Text(Properties.menu)
                        .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
            }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
            VStack {

                UserView(id: userId)
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
                            .background(Color.cyan)
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))

                    Button(action: {
                        addProject(token: token)
                    }) {
                        Text(Properties.addProject)
                                .font(.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                                .frame(width: 150, height: 30)
                                .foregroundColor(.black)
                                .background(Color.secondary.opacity(0.5))
                                .cornerRadius(10)
                    }
                            .alert(isPresented: $showAlert, content: getAlert)

                }
            }
            List {
                ForEach(project) { item in
                    NavigationLink(destination: AppView(project: item, showProject: true, userId: userId, token: token)) {
                            ListRowView(project: item, token:token)
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
                .background(ApplicationTheme.shared.defaultColor.color)
    }

    func moveProject(from source: IndexSet, to destination: Int) {
        projectView.projects.move(fromOffsets: source, toOffset: destination)
        do {
            try ProjectTable.shared.updateProjectTable()
        } catch {
            toastMessage = "\(error)"
            isToastVisible.toggle()
        }
    }

    func addProject(token:String) -> Void {
        if textIsAppropriate() {
                ProjectAPIService.shared.create(name: textField, description: "description", token:token) { result, error in
                    if let error = error  {
                        toastMessage = "\(error)\n" + Properties.projectCreatedUnSuccess
                        isToastVisible.toggle()
                    } else if result == true  {
                        toastMessage = Properties.projectCreatedSuccess
                        isToastVisible.toggle()
                    } else {
                        toastMessage = Properties.projectCreatedUnSuccess
                        isToastVisible.toggle()
                    }
                }
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
            Image(systemName: Properties.arrowLeftCircleImage)
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




