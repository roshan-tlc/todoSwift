//
// Created by Krithik Roshan on 06/09/23.
//

import Foundation
import SwiftUI


struct LoginView: View {

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showLogin = false
    @State private var isPasswordVisible = false
    @State private var isToastVisible = false
    @State private var toastMessage = ""
    @State private var user:User?
    @State private var userId:Int64?

    init() {
        do {
            try UserTable.shared.createTable()

            try ProjectTable.shared.createTable()
            try TodoTable.shared.createTable()
            try ThemeTable.shared.createTable()
            try CredentialTable.shared.createTable()

            if try ThemeTable.shared.getFirstId() == 0 {
                try ThemeTable.shared.insert(theme: ApplicationTheme.shared)
            }

            ApplicationTheme.shared.defaultColor = try ThemeTable.shared.getColor()
            ApplicationTheme.shared.fontSize = try ThemeTable.shared.getFontSize()
            ApplicationTheme.shared.fontFamily = try ThemeTable.shared.getFontFamily()
        } catch {
            toastMessage = "Error at \(error)"
            isToastVisible.toggle()
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ApplicationTheme.shared.defaultColor.color
                        .edgesIgnoringSafeArea(.all)
                VStack {

                    Text("Login")
                            .font(.title2)
                            .padding(.bottom, 30)
                    VStack(spacing: 30) {
                        TextField("Email", text: $email)
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .frame(width: .infinity, height: 50)

                        PasswordView(isPasswordVisible: $isPasswordVisible, password: $password, text: "Enter Your password")

                        HStack {
                            Spacer()

                            NavigationLink(destination: ForgotPasswordView(email: $email)) {
                                Text("Forgot Password")
                                        .underline()
                                        .font(.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                                        .padding()
                                        .foregroundColor(.blue)

                            }
                        }

                        HStack {

                                NavigationLink("", destination: AppView(userId: userId ?? 0), isActive: $showLogin)
                                Button(action: {
                                        //userId = try UserList.shared.userValidation(email: email, password: UserValidation.shared.encryptPassword(password))

                                Authentication.shared.signIn(email: email, password: password) { id, error in
                                    if let error = error {
                                        toastMessage = "\(error)"
                                            isToastVisible.toggle()
                                        }
                                    if id != 0 {
                                        userId = id
                                        showLogin.toggle()
                                    }
                                }

                                    if userId != 0 && userId != nil {
                                        showLogin.toggle()
                                    } else {
                                        if email.isEmpty {
                                            toastMessage.append("email is empty\n")
                                        }
                                        if password.isEmpty {
                                            toastMessage.append("password is empty\n")
                                        } else {
                                            toastMessage = "Invalid email or password \n Sign In UnSuccessful"
                                        }
                                        isToastVisible.toggle()
                                    }
                                }) {
                                    Text("Sign In")
                                            .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
                                            .padding(.vertical)
                                            .foregroundColor(.primary)
                                            .frame(width: UIScreen.main.bounds.width - 50)
                                }
                                        .background(.secondary)
                                        .cornerRadius(10)
                                        .padding(.bottom, 10)
                        }
                                .toast(isPresented: $isToastVisible, message: $toastMessage)
                    }


                    HStack {

                        Text("Don't have an account ?")
                                .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, fixedSize: ApplicationTheme.shared.fontSize.rawValue))
                                .padding()
                                .foregroundColor(.white)

                        NavigationLink(destination: SignUpView()) {
                            Text("SignUp")
                                    .underline()
                                    .font(.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
                                    .padding()
                                    .foregroundColor(.blue)
                        }

                        Spacer()

                    }
                            .padding(.top, 40)

                }
                        .padding()
            }
        }
                .navigationBarBackButtonHidden(true) //
    }
}

struct ToastView: View {
    var message: String

    var body: some View {
        Text(message)
                .padding()
                .background(Color.primary)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .opacity(0.8)
                .padding(.horizontal, 20)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var message: String

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                ToastView(message: message)
                        .offset(y: 180)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isPresented = false
                            }
                        }
                        .onDisappear {
                            message = ""
                        }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: Binding<String>) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}
