//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserView : View {
    
    @State var user:User
    
    init (id:Int64) {
        user = UserList().get(id: id)
    }

    var body : some View {
        HStack {
            HStack {
                ZStack {
                    Circle()
                            .foregroundColor(.blue)
                            .frame(width: 90, height: 60)
                            

                    Text(user.getName().prefix(1).uppercased())
                        .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue , size : ApplicationTheme.shared.fontSize.rawValue))
                            .foregroundColor(.white)
                }
                        .padding(.leading, 10)
            }

            VStack {
                Text(user.getName())
                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue , size : ApplicationTheme.shared.fontSize.rawValue))
                        .foregroundColor(.black)
                        .padding(5)

                Text(user.getDescription())
                    .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue , size : ApplicationTheme.shared.fontSize.rawValue))
                        .foregroundColor(.black)
                        .padding(5)
            }
                    .frame(width: 100)
            NavigationLink(destination: UserEditView(userId: user.id, userName: user.getName(), description: user.getDescription())) {
                Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.blue)
                        .padding(.leading, 30)
            }
                    .onAppear { reload() }
            Spacer()
        }
                .frame(width: .infinity, height: 80,alignment: .top)
    }
    
    func reload() {
        user = UserList().get(id: user.id)
    }
}
