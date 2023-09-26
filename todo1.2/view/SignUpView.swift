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
    @State var description = ""
    @State var hint = ""
    @State var showLogin = false
    @State var isPasswordVisible = false
    @State var isToastVisible = false
    @State var toastMessage = ""
    private var id:Int64 = 1
    @Environment(\.presentationMode) var presentation

    private var isNotEmpty: Bool {
        !name.isEmpty
    }

    var body : some View {
        ZStack {
            Color.white
            .edgesIgnoringSafeArea(.all)

            VStack {

                Text(Properties.registerUser)
                        .font(.title2)
                        .padding(.bottom, 50)
                VStack(spacing: 20) {

                    TextField(Properties.name, text: $name)
                            .accessibility(hint: Text(Properties.emptyText))
                            .padding()
                            .background(.white).border(.primary, width: 0.5)
                            .foregroundColor(.primary)
                            .frame(width: .infinity, height: 50)

                    TextField(Properties.email, text: $email)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.primary).border(.primary, width: 0.5)
                            .frame(width: .infinity, height: 50)

                    TextField(Properties.description, text: $description)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.primary).border(.primary, width: 0.5)
                            .frame(width: .infinity, height: 50)

                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $password, text: Properties.enterPassword)
                    PasswordView(isPasswordVisible: $isPasswordVisible, password: $reEnteredPassword, text: Properties.reEnterPassword)

                    TextField(Properties.newHint, text: $hint)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.primary).border(.primary, width: 0.5)
                            .frame(width: .infinity, height: 50)

                    HStack {

                        NavigationLink("", destination:LoginView(), isActive: $showLogin) //

                        Button(action: {
                            do {
                                let emails = try CredentialTable.shared.getAllEmail()
                                if UserValidation.shared.validateUserDetails(name: name, email: email, password: password, reEnteredPassword: reEnteredPassword) {
                                    let user = User(id: id, name: name, description: description, email: email)
                                    let credential = Credential(id: id, email: email, password: password, hint: hint)

                                    Authentication.shared.signUp(user: user, credential: credential) { result, error in
                                        print(result, error)
                                        if let error = error {
                                            toastMessage = "\(error)"
                                            isToastVisible.toggle()
                                        } else {
                                            toastMessage = Properties.signUpSuccessful
                                            isToastVisible.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                showLogin.toggle()
                                            }
                                        }
                                    }
                                } else {
                                    if password != reEnteredPassword {
                                        toastMessage = Properties.passwordMisMatched
                                        isToastVisible.toggle()
                                    }
                                    if !email.isEmpty && emails.contains(emails) {
                                        toastMessage = Properties.emailExists
                                        isToastVisible.toggle()
                                    } else {
                                        toastMessage = Properties.invalidData
                                        isToastVisible.toggle()
                                    }
                                }
                            } catch {
                                toastMessage = "\(error)"
                                isToastVisible.toggle()
                            }
                        }) {
                            Text(Properties.signUp)
                                    .font(Font.custom(ApplicationTheme.shared.fontFamily, fixedSize: ApplicationTheme.shared.fontSize))
                                    .padding(.vertical)
                                    .foregroundColor(.primary)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                        }
                                .background(.secondary)
                                .cornerRadius(10)
                                .padding(.top, 40)
                    }
                            .toast(isPresented: $isToastVisible, message: $toastMessage)
                }
                HStack {

                    Text(Properties.alreadyHaveAnAccount)
                            .font(Font.custom(ApplicationTheme.shared.fontFamily, fixedSize: ApplicationTheme.shared.fontSize))
                            .padding()
                            .foregroundColor(.secondary)

                    NavigationLink(destination: LoginView()) {
                        Text(Properties.signIn)
                                .underline()
                                .font(.custom(ApplicationTheme.shared.fontFamily, size: ApplicationTheme.shared.fontSize))
                                .padding()
                                .foregroundColor(.primary)

                    }
                }
            }
                    .padding(30)
                    .padding(.bottom, 100)
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
                            .font(Font.custom(ApplicationTheme.shared.fontFamily, size: ApplicationTheme.shared.fontSize))
                            .padding()
                            .frame(width: .infinity, height: 50).accentColor(.primary).multilineTextAlignment(.center)
                            .border(.primary, width: 0.5)
                            .cornerRadius(10)
                } else {
                    SecureField(text, text: $password)
                            .font(Font.custom(ApplicationTheme.shared.fontFamily, size: ApplicationTheme.shared.fontSize))
                            .padding()
                            .foregroundColor(.primary)
                            .frame(width: .infinity, height: 50).accentColor(.primary).multilineTextAlignment(.center)


                }
            }

            Button(action: { isPasswordVisible.toggle() }) {
                Image(systemName: isPasswordVisible ? Properties.eyeFillImage: Properties.eyeSlashFillImage)
            }
        }
                .padding()
                .foregroundColor(.primary)
                .frame(width: .infinity, height: 50).accentColor(.primary).multilineTextAlignment(.center)
                .border(.primary, width: 0.5)

    }
}
