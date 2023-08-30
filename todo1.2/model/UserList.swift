
//
// Created by Krithik Roshan on 28/08/23.
//
import Foundation

class UserList : ObservableObject{
    @Published var usersList = [User]()
    private let userTable =  UserTable.shared
    private var id = 1

    func addUser(id: String, name:String, description:String) {
        if userTable.get().contains(where: { $0.id == id }){
            userTable.update(id: Int64(id)!, name: name, description: description)
            
        } else {
            //usersList.append(User(id: String(id), name: name, description: description))
            userTable.insert(user: User(id: String(id), name: name, description: description))
            
            print(usersList)
        }
    }

    func removeUser(id:String) {
//        if let id = usersList.firstIndex(where: { $0.id == id }) {
//            usersList.remove(at: id)
//        }
        userTable.remove(id: id)
    }
    
    func get(id:String) -> User {
//        if let index = usersList.firstIndex(where :{ $0.id == id}) {
//            return usersList[index]
//        }
        
        return userTable.get(id:Int64(id)!)
    }
    
    func get() -> [User] {
        return userTable.get()
    }
}
