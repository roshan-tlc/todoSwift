//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserEditView: View {
    
    @State var userId:String
    @State var userName:String
    @State var description:String
    @State var email:String
    @State var token:String
    @State var toastMessage = ""
    @State var isToastVisible = false
    @State var fontSize : CGFloat = ApplicationTheme.shared.fontSize
    @State var fontFamily : String = ApplicationTheme.shared.fontFamily
    @State var defaultColor : Color = ApplicationTheme.shared.defaultColor
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Circle()
                            .frame(width: 120, height: 120, alignment: .centerFirstTextBaseline)
                            .foregroundColor(.blue)
                            .padding()

                    Text(userName.prefix(1).uppercased())
                            .font(Font.custom(fontFamily, size : fontSize))
                            .foregroundColor(.white)
                            .padding()
                }
                TextField(Properties.name, text: $userName)
                        .font(Font.custom(fontFamily, size : fontSize))
                        .frame(alignment: .center)
                        .padding(.leading, 100)
                        .padding()

                TextField(Properties.description, text: $description)

                        .frame(alignment: .center)
                        .padding(.leading, 100)
                        .padding()

                TextField(Properties.email, text: $email)

                        .frame(alignment: .center)
                        .padding(.leading, 100)
                        .padding()

                HStack(spacing: 20) {

                    Button(action: {
                        UserList.shared.update(id: userId, name: userName, title: description, token: token)
                        
                        presentation.wrappedValue.dismiss()
                    }) {
                        Text(Properties.save)
                    }
                            .frame(width: 80)
                            .font(Font.custom(fontFamily, size : fontSize))
                            .padding()

                    Button(action: {

                        presentation.wrappedValue.dismiss()
                    }) {
                        Text(Properties.cancel)
                    } .frame(width: 80)
                            .font(Font.custom(fontFamily, size : fontSize))
                            .padding()
                }
            }
        }
                .background(ApplicationTheme.shared.defaultColor)
                .toast(isPresented: $isToastVisible, message: $toastMessage)
    }
}
