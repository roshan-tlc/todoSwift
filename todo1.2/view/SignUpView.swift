//
// Created by Krithik Roshan on 06/09/23.
//

import Foundation
import SwiftUI

struct SignUpView : View {
    @State var name:String = ""
    @State var email:String = ""
    @State var password:String = ""
    @State var reEnteredPassword = ""
    @State var showLogin = false
    @State var isPasswordVisible = false
    @State var isToastVisible = false
    @State var message = ""
    @Environment(\.presentationMode) var presentation
    private var isNotEmpty: Bool {
        !name.isEmpty
    }

    var body : some View {
        ZStack {
            ApplicationTheme.shared.defaultColor.color
                    .edgesIgnoringSafeArea(.all)

            VStack {

                Text("Register User")
                        .font(.title2)
                        .padding(.bottom, 50)
                VStack(spacing: 30) {

                        TextField("  Name", text: $name)
                                .accessibility(hint: Text("Text is not empty"))
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(width: .infinity, height: 50)

                    TextField("  Email", text: $email)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .frame(width: .infinity, height: 50)

                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $password, text: "Enter Your Password")
                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $reEnteredPassword, text: "Re Enter Your Password")

                    HStack {

                        NavigationLink("", destination:LoginView(), isActive: $showLogin)
                                .navigationBarBackButtonHidden(true)
                        Button(action: {

                            if UserValidation.shared.validateUserDetails(name: name, email: email, password: password, reEnteredPassword: reEnteredPassword) {
                                UserList.shared.add(name: name, description: "", email: email, password: password)
                                showLogin.toggle()
                            }
                            else {
                                message = "Enter a valid details"
                                isToastVisible.toggle()
                            }
                        }) {
                            Text("Sign Up")
                                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
                                    .padding(.vertical)
                                    .foregroundColor(.primary)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                        }
                                .background(.secondary)
                                .cornerRadius(10)
                                .padding(.top, 40)
                    }
                            .toast(isPresented: $isToastVisible, message: $message)
                }
                Spacer()

                HStack {

                    Text("Already have an account ?")
                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
                            .padding()
                            .foregroundColor(.white)

                    NavigationLink(destination: LoginView()) {
                        Text("SignIn")
                                .underline()
                                .font(.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                                .padding()
                                .foregroundColor(.blue)
                                .navigationBarBackButtonHidden(true)
                    }
                    Spacer()
                    Spacer()
                }
            }
        }

    }
}

struct PasswordView : View {
    @Binding var isPasswordVisible:Bool
    @Binding var password : String
    @State var text:String

    var body : some View {
        HStack {
            VStack {

                if isPasswordVisible {
                    TextField(text, text: $password)
                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                            .padding()
                            .foregroundColor(.black)
                            .background(.white)
                            .frame(width: .infinity, height: 50)
                            .cornerRadius(10)
                } else {
                    SecureField(text, text: $password)
                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                            .padding()
                            .foregroundColor(.black)
                            .background(.white)
                            .frame(width: .infinity, height: 50)
                            .cornerRadius(10)
                }
            }

            Button(action: { isPasswordVisible.toggle() }) {
                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
            }
        }
                .padding()
                .foregroundColor(.black)
                .background(.white)
                .frame(width: .infinity, height: 50)
                .cornerRadius(10)

    }


}