//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserEditView: View {
    @State var userId:Int64
    @State var userName:String
    @State var description:String
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
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                }
                TextField("New Name", text: $userName)
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
                        .frame(width: 40)
                        .padding()
                        
                        Button(action: {

                            presentation.wrappedValue.dismiss()
                        }) {
                            Text("Cancle")
                        } .frame(width: 60)
                            .padding()
                    }
            }
        }
    }
}
