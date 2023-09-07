//
// Created by Krithik Roshan on 06/09/23.
//

import Foundation

class Credential : Identifiable {
    internal let id : Int64
    private let email : String
    private let password : String

    init(id:Int64, email:String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }

    func getId() -> Int64 {
        id
    }

    func getEmail() -> String {
        email
    }

    func getPassword() -> String {
        password
    }
}