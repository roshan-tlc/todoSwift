//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserEditView: View {
    @State var userId:Int64
    @State var userName:String
    @State var description:String
    @State var fontSize : ApplicationTheme.FontSize = ApplicationTheme.shared.fontSize
    @State var fontFamily : ApplicationTheme.FontFamily = ApplicationTheme.shared.fontFamily
    @State var defaultColor : ApplicationTheme.DefaultColor = ApplicationTheme.shared.defaultColor
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
                            .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
                            .foregroundColor(.white)
                            .padding()
                }
                TextField("New Name", text: $userName)
                        .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
                        .frame(alignment: .center)
                        .padding(.leading, 100)
                        .padding()

                TextField("New Description", text: $description)

                        .frame(alignment: .center)
                        .padding(.leading, 100)
                        .padding()

                HStack(spacing: 20) {

                    Button(action: {
                        UserList().addUser(id: userId, name: userName, description: description)
                        presentation.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }
                            .frame(width: 80)
                            .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
                            .padding()

                    Button(action: {

                        presentation.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    } .frame(width: 80)
                            .font(Font.custom(fontFamily.rawValue, size : fontSize.rawValue))
                            .padding()
                }
                Spacer()
            }
        }
                .background(ApplicationTheme.shared.defaultColor.color)
    }
}
