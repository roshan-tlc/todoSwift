//
// Created by Krithik Roshan on 28/08/23.
//

import SwiftUI

struct UserView : View {
    
    @State var user:User
    @State var themeColor : Color = ApplicationTheme.shared.getDefaultColor()
    @State var fontFamily:String = ApplicationTheme.shared.fontFamily.rawValue
    @State var fontSize:CGFloat = ApplicationTheme.shared.fontSize.rawValue
    
    init (id:Int64) {
        user = UserList().get(id: id)
    }

    var body : some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 80)
                            .foregroundColor(themeColor)

                    Text(user.getName().prefix(1).uppercased())
                            .font(Font.custom(fontFamily , size : fontSize))
                            .foregroundColor(.white)
                }
                        .padding(.leading,80)

                NavigationLink(destination: UserEditView(userId: user.id, userName: user.getName(), description: user.getDescription())) {
                    Image(systemName: "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(.leading, 30)
                }
                .onAppear {reload()}
            }
            Text(user.getName())
                    .font(Font.custom(fontFamily , size : fontSize))
                    .foregroundColor(.black)
                    .padding(5)

            Text(user.getDescription())
                    .font(Font.custom(fontFamily , size : fontSize))
                    .foregroundColor(.black)
                    .padding(5)

            Divider()
        }
    }
    
    func reload() {
        user = UserList().get(id: user.id)
    }
}
