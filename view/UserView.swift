//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserView : View {
    @State var userName:String = "User"
    @State var description:String = "Description"

    var body : some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 80)

                    Text(userName.prefix(1).uppercased())
                            .font(.title)
                            .foregroundColor(.white)
                }
                        .padding(.leading,80)

                NavigationLink(destination: UserEditView(userName: $userName, userDescription: $description )) {
                    Image(systemName: "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(.leading, 30)
                }
            }
            Text(userName)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(5)

            Text(description)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(5)

            Divider()

        }
    }
}
