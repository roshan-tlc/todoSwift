//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserView : View {

    @State private var user:APIUser
    @State private var toastMessage = ""
    @State private var isToastVisible = false
    @State var token:String

    init(id: String) {
        UserAPIService.shared.get(token: token) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(_) :
                toastMessage = Properties.getUserUnsuccessful
                isToastVisible.toggle()
            }
            
        }
    }

    var body : some View {
        HStack {
            HStack {
                ZStack {
                    Circle()
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 60)

                    Text(user.getName().prefix(1).uppercased())
                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue , size : ApplicationTheme.shared.fontSize.rawValue))
                            .foregroundColor(.white)
                }
                        .padding(.leading, 10)
            }

            VStack {
                Text(user.getName() )
                        .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue , size : ApplicationTheme.shared.fontSize.rawValue))
                        .foregroundColor(.black)
                        .padding(5)

                Text(user.getDescription() )
                        .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue , size : ApplicationTheme.shared.fontSize.rawValue))
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                        .padding(5)
            }
                    .frame(width: 130)

            VStack {
                NavigationLink(destination: LoginView()) {
                    Image(systemName: Properties.logoutImage)
                            .frame(width: 6, height: 6)
                            .foregroundColor(.blue)
                            .padding(.leading, 5)
                            .padding(.bottom, 10)
                }

                NavigationLink(destination: UserEditView(userId: user.id, userName: user.getName() , description: user.getDescription(), email: user.getEmail())) {
                    Image(systemName: Properties.editImage)
                            .foregroundColor(.blue)
                            .padding(.leading, 5)
                            .padding()
                }
                        .onAppear {
                            reload()
                        }
            }
            Spacer()
        }
        .padding(15)
                .toast(isPresented: $isToastVisible, message: $toastMessage)
                .frame(width: .infinity, height: 80,alignment: .top)
    }

    func getUser(userId:String) -> User {
        do {
            return try UserList.shared.get(id: userId)
        } catch {
            toastMessage = "\(error)"
            return User(id: 0, name: "", description: "", email: "")
        }
    }
    
    func reload() {
        user = getUser(userId: String(user.getId()))
    }
}
