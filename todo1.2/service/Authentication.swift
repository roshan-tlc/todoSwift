//
// Created by Krithik Roshan on 13/09/23.
//

import Foundation

class Authentication: ObservableObject {
    
    static let shared = Authentication()
    
    private init() {
    }
    
    func signUp(user: User, credential: Credential, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/user/signup") else {
            completion(false, APIService.APIErrors.INVALID_URL)
            return
        }
        var request = URLRequest(url: url)
        
        let userData = [
            Properties.name: user.getName(),
            Properties.title: user.getDescription(),
            Properties.email: user.getEmail(),
            Properties.password: credential.getPassword(),
            Properties.hint: credential.getHint()
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: userData) {
            request.httpMethod = DBProperties.post
            request.httpBody = jsonData
            request.setValue(Properties.applicationJson, forHTTPHeaderField: Properties.contentType )
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(true, error)
                    } else {
                        completion(false, APIService.APIErrors.INVALID_RESPONSE)
                    }
                } else if let error = error {
                    completion(false, error)
                }
            }
            .resume()
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool , String, Error?) -> Void) {
        
        var token:String = ""
        
        guard let url = URL(string:DBProperties.baseUrl + "/api/v1/user/login") else {
            completion(false,token, APIService.APIErrors.INVALID_URL)
            return
        }
        
        let credentials = [Properties.email: email, Properties.password : password]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: credentials)
            
            var request = URLRequest(url: url)
            request.httpMethod = DBProperties.post
            request.httpBody = jsonData
            
            request.addValue(Properties.applicationJson, forHTTPHeaderField: Properties.contentType)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    completion(false,token, error)
                    return
                }
                
                if let data = data {
                    do {
                        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                        token = tokenResponse.data.token
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            completion(true, token, nil)
                        } else {
                            completion(false,token,  nil)
                        }
                    }
                
            }
            task.resume()
        } catch {
            completion(false,token, error)
        }
    }
    
    func forgotPassword(email:String, password:String, oldHint:String, newHint: String, completion : @escaping (Bool, Error?) -> Void) {
        
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/user/reset/password")  else {
            completion(false, APIService.APIErrors.INVALID_URL)
            return
        }
        
        let credential = [Properties.email : email, Properties.password : password, Properties.oldHint : oldHint, Properties.newHint : newHint]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: credential)
            
            var request =  URLRequest(url: url)
            request.httpMethod = DBProperties.post
            request.httpBody = jsonData
            request.addValue(Properties.applicationJson, forHTTPHeaderField: Properties.contentType)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(false, error)
                }
                
                guard let data = data else {
                    completion(false, nil)
                    return
                }
                
                if let httResponse = response as? HTTPURLResponse {
                    if httResponse.statusCode == 200 {
                        completion(true, nil)
                    } else {
                        completion(false, nil)
                    }
                }
            }
            task.resume()
        } catch {
            completion(false, APIService.APIErrors.INVALID_RESPONSE)
        }
        
    }
}

struct TokenResponse : Decodable {
    let success: Bool
    let message: String
    let data: TokenData
}

struct TokenData: Decodable {
    let token: String
}
