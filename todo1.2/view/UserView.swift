//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserView : View {

    @State private var user:APIUser
    @State var userName:String
    @State var description:String
    @State private var toastMessage = ""
    @State private var isToastVisible = false
    @State var token:String

    init(user:APIUser, token:String) {
        self.user = user
        self.token = token
        userName = user.getName()
        description = user.getTitle()
    }

    var body : some View {
        HStack {
            HStack {
                ZStack {
                    Circle()
                            .foregroundColor(.primary)
                            .frame(width: 80, height: 60)

                    Text(user.getName().prefix(1).uppercased())
                        .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue , size : ApplicationTheme.shared.fontSize.rawValue))
                            .foregroundColor(.white)
                }
                        .padding(.leading, 10)
            }

            VStack {
                Text(user.getName() )
                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size : ApplicationTheme.shared.fontSize.rawValue))
                        .foregroundColor(.primary)
                        .padding(5)

                Text(user.getTitle() )
                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue , size : ApplicationTheme.shared.fontSize.rawValue))
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                        .padding(5)
            }
                    .frame(width: 130)

            VStack {
                NavigationLink(destination: LoginView()) {
                    Image(systemName: IconProperties.logoutImage)
                            .frame(width: 6, height: 6)
                            .foregroundColor(.primary)
                            .padding(.leading, 5)
                            .padding(.bottom, 10)
                }

                NavigationLink(destination: UserEditView(userId: user.id, userName: user.getName() , description: user.getTitle(), email: user.getEmail(), token: token)) {
                    Image(systemName: IconProperties.editImage)
                            .foregroundColor(.primary)
                            .padding(.leading, 5)
                            .padding()
                }

            }
            Spacer()
        }
                .onAppear {
                    reload()
                }
        .padding(15)
                .toast(isPresented: $isToastVisible, message: $toastMessage)
                .frame(width: .infinity, height: 80,alignment: .top)
    }

    func getUser()  {
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
    
    func reload() {
        DispatchQueue.main.async {
            getUser()
        }
    }
}
