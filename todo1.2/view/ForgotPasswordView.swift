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
                        .padding(.horizontal,20)

                VStack(spacing: 30) {

                    TextField("  Email", text: $email)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .frame( height: 50)
                            .padding(.horizontal, 20)

                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $password, text: "Enter Your Password")
                            .padding(.horizontal, 20)
                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $reEnteredPassword, text: "Re Enter Your Password")
                            .padding(.horizontal, 20)

                    HStack {
                        NavigationLink( destination: LoginView(), isActive: $showLogin) {Text("")}
                                .navigationBarBackButtonHidden(true)

                        Button(action: {
                            password = UserValidation.shared.encryptPassword(password)
                            reEnteredPassword = UserValidation.shared.encryptPassword(reEnteredPassword)

                            if !email.isEmpty && !password.isEmpty && !reEnteredPassword.isEmpty && password == reEnteredPassword {
                                do {
                                    try UserList.shared.updatePassword(email: email, password: password)
                                } catch {
                                    message = "\(error)"
                                    isToastVisible.toggle()
                                }
                                print(email, password)
                                showLogin.toggle()
                            } else if (password != reEnteredPassword ){
                                message = "passwords are not matched"
                            } else {
                                message = "email doesn't exists"
                            }
                            isToastVisible.toggle()
                        }) {
                            Text("Reset Password")
                                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
                                    .padding(.vertical)
                                    .foregroundColor(.primary)
                                    .frame(width: UIScreen.main.bounds.width - 250)
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
                                    .frame(width: UIScreen.main.bounds.width - 250)
                        }
                                .background(.secondary)
                                .cornerRadius(10)
                                .padding(.top, 40)
                    }
                            .padding()
                }
                Spacer()
            }

                    .padding(.vertical, 140)
        }
                .navigationBarBackButtonHidden(true)
                .toast(isPresented: $isToastVisible, message: $message)
    }
}
