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
    @State var oldHint = ""
    @State var newHint = ""
    @State var isToastVisible = false
    @State var toastMessage = ""
    @State var isPasswordVisible = false
    @Environment(\.presentationMode) var presentation

    var body : some View {
        ZStack {
            ApplicationTheme.shared.defaultColor.color
                    .edgesIgnoringSafeArea(.all)

            VStack {
                Text(Properties.forgotPassword)
                        .font(.title2)
                        .padding(.bottom, 50)
                        .padding(.horizontal,20)

                VStack(spacing: 30) {

                    TextField(Properties.email, text: $email)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .frame( height: 50)
                            .padding(.horizontal, 20)

                    TextField(Properties.oldHint, text: $oldHint)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .frame( height: 50)
                            .padding(.horizontal, 20)

                    TextField(Properties.newHint, text: $newHint)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .frame( height: 50)
                            .padding(.horizontal, 20)

                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $password, text: Properties.enterPassword)
                            .padding(.horizontal, 20)
                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $reEnteredPassword, text: Properties.reEnterPassword)
                            .padding(.horizontal, 20)

                    HStack {
                        NavigationLink( destination: LoginView(), isActive: $showLogin) {Text("")}
                                .navigationBarBackButtonHidden(true)

                        Button(action: {

                            if !email.isEmpty && !password.isEmpty && !reEnteredPassword.isEmpty && password == reEnteredPassword {
                                Authentication.shared.forgotPassword(email: email, password: password, oldHint: oldHint, newHint: newHint) { result, error in
                                    print(result, error)
                                    if let error = error  {
                                        toastMessage = "\(error) " + Properties.passwordChangeUnSuccessful
                                        isToastVisible.toggle()
                                    }

                                    if result == true {
                                        toastMessage = Properties.passwordChangeSuccessful
                                        isToastVisible.toggle()
                                        showLogin.toggle()
                                    } else {
                                        toastMessage = Properties.passwordChangeSuccessful
                                        isToastVisible.toggle()
                                    }
                                }

                            } else if (password != reEnteredPassword ){
                                toastMessage = Properties.passwordMisMatched
                                isToastVisible.toggle()
                            } else {
                                toastMessage = Properties.emailNotExists
                                isToastVisible.toggle()
                            }

                        }) {
                            Text(Properties.resetPassword)
                                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
                                    .padding(.vertical)
                                    .foregroundColor(.primary)
                                    .frame(width: UIScreen.main.bounds.width - 250)
                        }
                                .background(.secondary)
                                .cornerRadius(10)
                                .padding(.top, 40)
                                .toast(isPresented: $isToastVisible, message: $toastMessage)

                        Button(action: {
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text(Properties.cancel)
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
                .toast(isPresented: $isToastVisible, message: $toastMessage)
    }
}
