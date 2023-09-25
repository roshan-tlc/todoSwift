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
    @State var toastMessage = ""
    @State var isToastVisible = false
    @State var token:String

    var body: some View {
        HStack {
            TextView(text: project.getTitle())
                .font(Font.custom(ApplicationTheme.shared.fontFamily, size: ApplicationTheme.shared.fontSize))
            
            Image(systemName: Properties.minusCircleImage)
                    .onTapGesture(perform: remove)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 20)
                    .foregroundColor(.primary)
        }
    }
        
    
    func remove() {
        ProjectAPIService.shared.remove(id: project.getId(), token: token) { result, error in
            ProjectList.shared.remove(id: project.getId())
            if let error = error  {
                toastMessage = "\(error)"
                isToastVisible.toggle()
            } else if result == true {
                toastMessage = Properties.projectRemoveSuccess
                isToastVisible.toggle()
            } else {
                toastMessage = Properties.projectRemoveUnSuccess
                isToastVisible.toggle()
            }
        }
        ProjectList.shared.remove(id: project.getId())
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
