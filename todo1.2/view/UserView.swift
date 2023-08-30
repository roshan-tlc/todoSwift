//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserView : View {
    
    @State var user:User
    
    init (id:String) {
        user = UserList().get(id: id)
    }

    var body : some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 80)

                    Text(user.name.prefix(1).uppercased())
                            .font(.title)
                            .foregroundColor(.white)
                }
                        .padding(.leading,80)

                NavigationLink(destination: UserEditView(userId: user.id, userName: user.name, description: user.description)) {
                    Image(systemName: "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(.leading, 30)
                }
                .onAppear {reLoad()}
            }
            Text(user.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(5)

            Text(user.description)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(5)

            Divider()

        }
    }
    
    func reLoad() {
        user = UserList().get(id: user.id)
    }
}
