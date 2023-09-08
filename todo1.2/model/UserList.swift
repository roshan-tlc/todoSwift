
//
// Created by Krithik Roshan on 28/08/23.
//
import Foundation

class UserList : ObservableObject{
    @Published var usersList = [User]()
    private let userTable =  UserTable.shared
    private let credentialTable = CredentialTable.shared
    private var id:Int64 = 1
    static var shared = UserList()

    private init () {}

    func add (name:String, description:String, email:String, password:String) {
        userTable.insert(user: User(id: id, name: name, description: description, email: email))
        credentialTable.insert(id:userTable.getId(email: email), email: email, password: password)
        id += 1
    }

    func update (id: Int64, name:String, description:String, email:String) {
        userTable.update(id: id, name: name, description: description, email : email)
    }

    func userValidation(email:String, password:String) -> Int64 {
         credentialTable.validation(email: email, password: password)
    }

    func updatePassword(email:String, password:String) {
        credentialTable.updatePassword(email: email, password: password)
        print(email, password)
    }

    func getId(email:String) -> Int64 {
        userTable.getId(email: email)
    }

    func remove(id:Int64) {
        userTable.remove(id: id)
        credentialTable.remove(id: id)
    }
    
    func get(id:Int64) -> User {
         userTable.get(id:id)
    }
    
    func get() -> [User] {
         userTable.get()
    }
}
