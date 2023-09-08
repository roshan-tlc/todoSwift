//
// Created by Krithik Roshan on 06/09/23.
//

import Foundation
import SwiftUI

struct ForgotPasswordView : View {
    @Binding var email:String
    @State var password:String = ""
    @State var reEnteredPassword = ""
    @State var showLogin = false
    @State var isToastVisible = false
    @State var message = ""
    @State var isPasswordVisible = false
    @Environment(\.presentationMode) var presentation

    var body : some View {
        ZStack {
            ApplicationTheme.shared.defaultColor.color
                    .edgesIgnoringSafeArea(.all)

            VStack {

                Text("Forgot Password ?")
                        .font(.title2)
                        .padding(.bottom, 50)
                VStack(spacing: 30) {

                    TextField("  Email", text: $email)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .frame(width: .infinity, height: 50)

                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $password, text: "Enter Your Password")
                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $reEnteredPassword, text: "Re Enter Your Password")

                    HStack {
                        NavigationLink("", destination: LoginView(), isActive: $showLogin)
                                .navigationBarBackButtonHidden(true)

                        Button(action: {
                            if !email.isEmpty && !password.isEmpty && !reEnteredPassword.isEmpty && password == reEnteredPassword {
                                UserList.shared.updatePassword(email: email, password: password)
                                print(email, password)
                                showLogin.toggle()
                            } else {
                                message = "Email is not exists"
                            }
                            isToastVisible.toggle()
                        }) {
                            Text("Reset Password")
                                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
                                    .padding(.vertical)
                                    .foregroundColor(.primary)
                                    .frame(width: UIScreen.main.bounds.width - 200)
                        }
                                .background(.secondary)
                                .cornerRadius(10)
                                .padding(.top, 40)
                                .toast(isPresented: $isToastVisible, message: $message)

                        Button(action: {
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text("cancel")
                                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
                                    .padding(.vertical)
                                    .foregroundColor(.primary)
                                    .frame(width: UIScreen.main.bounds.width - 200)
                        }
                                .background(.secondary)
                                .cornerRadius(10)
                                .padding(.top, 40)
                    }
                }
                Spacer()
            }
        }
                .navigationBarBackButtonHidden(true)
    }
}