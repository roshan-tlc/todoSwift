//
// Created by Krithik Roshan on 07/09/23.
//

import Foundation
import CommonCrypto

class UserValidation: Identifiable {

    static let shared = UserValidation()

    private init() {
    }

    func validateName(name: String) -> Bool {
        let pattern = #"^[a-zA-Z]+"#
        if !name.isEmpty {
            // let result = name.range(of: pattern, options: .regularExpression)
            return true //result != nil
        }
        return false
    }

    func validateEmail(email: String) -> Bool {
        let pattern = #"^[a-z]"#
        if !email.isEmpty {
            //let result = email.range(of:pattern, options: .regularExpression)
            return true // result != nil
        }
        return false
    }

    func validatePassword(password: String) -> Bool {
        let pattern = #"^[a-z]"#
        if !password.isEmpty {
            // let result = password.range(of: pattern, options: .regularExpression)
            return true //result != nil
        }
        return false
    }

    func encryptPassword(_ password: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = password.data(using: .utf8) {
            _ = data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) in
                if let bytes = buffer.bindMemory(to: UInt8.self).baseAddress {
                    CC_MD5(bytes, CC_LONG(data.count), &digest)
                }
            }
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }



    func validateUserDetails(name: String, email: String, password: String, reEnteredPassword: String) -> Bool {

        if UserValidation.shared.validateName(name: name) && UserValidation.shared.validateEmail(email: email)
                   && UserValidation.shared.validatePassword(password: password) && password == reEnteredPassword {
            return true
        }
        return false
    }

}