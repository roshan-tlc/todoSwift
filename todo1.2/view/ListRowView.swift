//
//  ListRowView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct ListRowView : View {
    @State var project : APIProject;
    @EnvironmentObject var listView:ProjectList
    @State var message = ""
    @State var isToastVisible = false

    var body: some View {
        HStack {
            TextView(text: project.getTitle())
                .font(Font.custom(ApplicationTheme.shared.fontFamily.rawValue, size: ApplicationTheme.shared.fontSize.rawValue))
            
            Image(systemName: Properties.minusCircleImage)
                    .onTapGesture(perform: remove)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 20)
                    .foregroundColor(.primary)
        }
    }
    
    func remove() {
//        do {
//            try listView.removeProject(id: project.id, userId: project.getUserId())
//        } catch {
//            message = "\(error)"
//            isToastVisible.toggle()
//        }
    }
}

struct TextView : View {
    var text:String
    @State var textField:String = ""
    
    var body: some View {
        VStack {
            Text(text)
                .padding(.trailing, 110)
                .padding(.leading,0)
                .frame(width: 240, height: 20)
                    
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ProjectList.shared)
    }
}
