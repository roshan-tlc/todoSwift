//
// Created by Krithik Roshan on 28/08/23.
//
import Foundation

class UserList : ObservableObject{
    @Published var usersList = [User]()
    private var id = 1

    func addUser(name:String, description:String) {
        if usersList.contains(where: { $0.name == name }){
            
        } else {
            usersList.append(User(id: String(id), name: name, description: description))
            UserTable.shared.insert(user: User(id: String(id), name: name, description: description))
            print(usersList)
        }
    }

    func removeUser(id:String) {
        if let id = usersList.firstIndex(where: { $0.id == id }) {
            usersList.remove(at: id)
        }
    }
}
