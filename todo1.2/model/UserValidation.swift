//
// Created by Krithik Roshan on 07/09/23.
//

import Foundation

class UserValidation : Identifiable {

    static let shared = UserValidation()

    private init(){}

    func validateName(name:String) -> Bool {
        let pattern =  #"^[a-zA-Z]+"#
         if !name.isEmpty  {
            // let result = name.range(of: pattern, options: .regularExpression)
             return true //result != nil
         }
        return false
    }

    func validateEmail(email:String) -> Bool {
        let pattern = #"^[a-z]"#
        if !email.isEmpty {
            //let result = email.range(of:pattern, options: .regularExpression)
            return true // result != nil
        }
        return false
    }

    func validatePassword(password:String) -> Bool {
        let pattern = #"^[a-z]"#
        if !password.isEmpty {
           // let result = password.range(of: pattern, options: .regularExpression)
            return true //result != nil
        }
         return false
    }

    func validateUserDetails(name:String, email:String, password:String, reEnteredPassword:String) -> Bool {

        if UserValidation.shared.validateName(name:name) && UserValidation.shared.validateEmail(email: email)
                   && UserValidation.shared.validatePassword(password: password) && password == reEnteredPassword {
            return true
        }
        return false
    }

}