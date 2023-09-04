//
//  ListRowView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct ListRowView : View {
    @State var project : Project;
    @State var themeColor : Color = ApplicationTheme.shared.defaultColor.color
    @State var fontSize : CGFloat = ApplicationTheme.shared.fontSize.rawValue
    @State var fontStyle : String = ApplicationTheme.shared.fontFamily.rawValue
    @EnvironmentObject var listView:ProjectList
    
    
    var body: some View {
        HStack {
            TextView(text: project.getTitle())
                .font(Font.custom(fontStyle, size: fontSize))
            
            Image(systemName: "minus.circle.fill")
                .onTapGesture(perform: remove)
                .frame(width: 20, height: 20)
                .foregroundColor(themeColor)
        }
        .font(.title2)
    }
    
    func remove() {
        listView.removeProject(id: project.id, userId: project.getUserId())
    }
    
}

struct TextView : View {
    var text:String
    @State var themeColor : Color = ApplicationTheme.shared.defaultColor.color
    @State var textField:String = ""
    
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(themeColor)
                .padding(.trailing, 110)
                .padding(.leading,0)
                .frame(width: 240, height: 20)
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(ProjectList.shared)
    }
}
