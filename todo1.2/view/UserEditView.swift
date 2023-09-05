//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserEditView: View {
    @State var userId:Int64
    @State var userName:String
    @State var description:String
    @State var fontFamily : String = ApplicationTheme.shared.fontFamily.rawValue
    @State var fontSize : CGFloat = ApplicationTheme.shared.fontSize.rawValue
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
                TextField("New Name", text: $userName)
                        .font(Font.custom(fontFamily, size : fontSize))
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
                            .frame(width: 60)
                            .font(Font.custom(fontFamily, size : fontSize))
                            .padding()

                    Button(action: {

                        presentation.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    } .frame(width: 60)
                            .font(Font.custom(fontFamily, size : fontSize))
                            .padding()
                }
                Spacer()
            }
        }
                .background(ApplicationTheme.shared.defaultColor.color)
    }
}
