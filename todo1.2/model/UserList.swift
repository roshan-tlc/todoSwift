
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

    func add(name: String, description: String, email: String, password: String, hint: String, completion: @escaping (Bool) -> Void) {

    }


    func update (id: Int64, name:String, description:String, email:String) throws {
        do {
            try userTable.update(id: id, name: name, description: description, email: email)
        } catch {
            throw error
        }
    }

    func userValidation(email:String, password:String)  throws -> Int64 {
        do {
            //return try await LoginService.shared.signIn(email:email , password: password)
            return try credentialTable.validation(email: email, password: password)

        } catch {
            throw error
        }
    }

    func updatePassword(email:String, password:String) throws {
        do {
            return try credentialTable.updatePassword(email: email, password: password)
        } catch {
            throw error
        }
    }

    func getId(email:String) throws -> Int64 {
        do {
            return try userTable.getId(email: email)
        } catch {
            throw error
        }
    }

    func remove(id:Int64) throws  {
        do {
            try userTable.remove(id: id)
            try credentialTable.remove(id: id)
        } catch {
            throw error
        }
    }
    
    func get(id:String) throws -> User {
        do {
            return try userTable.get(id: id)
        } catch {
            throw error
        }
    }
    
    func get() throws -> [User] {
        do {
            return try userTable.get()
        } catch {
            throw error
        }
    }
}

struct Users {

}
