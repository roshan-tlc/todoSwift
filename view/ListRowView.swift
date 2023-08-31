//
//  ListRowView.swift
//  todo1.2
//
//  Created by Krithik Roshan on 18/08/23.
//

import SwiftUI

struct ListRowView : View {
    @State var project : Project;
    @EnvironmentObject var listView:ProjectList
    
    
    var body: some View {
        HStack {
            TextView(text: project.title)
            
            Image(systemName: "minus.circle.fill")
                .onTapGesture(perform: remove)
                .frame(width: 20, height: 20)
        }
        .font(.title2)
    }
    
    func remove() {
        listView.removeProject(id:project.id)
    }
    
}

struct TextView : View {
    var text:String
    @State var textField:String = ""
    
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(Color.black)
                .padding(.trailing, 110)
                .padding(.leading,0)
                .frame(width: 240, height: 20)
        }
    }
    
    
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(ProjectList())
    }
}
