//
// Created by Krithik Roshan on 13/09/23.
//

import Foundation

class Authentication: ObservableObject {

    static let shared = Authentication()

    private init() {}

    func signUp(user: User, credential: Credential, completion: @escaping (Bool, Error?) -> Void) {
        if let url = URL(string: "http://localhost:8080/api/v1/user/signup") {
            var request = URLRequest(url: url)

            let userData = [
                "name": user.getName(),
                "title": user.getDescription(),
                "email": user.getEmail(),
                "password": credential.getPassword(),
                "hint": credential.getHint()
            ]

            if let jsonData = try? JSONSerialization.data(withJSONObject: userData) {
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                URLSession.shared.dataTask(with: request) { data, response, error in
                            if let httpResponse = response as? HTTPURLResponse {
                                print("status code", httpResponse.statusCode)
                                if httpResponse.statusCode == 200 {
                                    completion(true, error)
                                } else {
                                    completion(false, error)
                                }
                            } else if let error = error {
                                completion(false, error)
                            }
                        }.resume()
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Int64?, Error?) -> Void) {
        if let url = URL(string: "http://localhost:8080/api/v1/user/login") {
            var request = URLRequest(url: url)

            let userData = [
                "email": email,
                "password": password
            ]

            if let jsonData = try? JSONSerialization.data(withJSONObject: userData) {
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                URLSession.shared.dataTask(with: request) { data, response, error in
                            if let error = error {
                                completion(nil, error)
                                return
                            }

                            guard let httpResponse = response as? HTTPURLResponse else {
                                completion(nil, NSError(domain: "Invalid Response", code: 0, userInfo: nil))
                                return
                            }

                            print("status code", httpResponse.statusCode)

                            if httpResponse.statusCode == 200, let data = data {
                                do {
                                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                       let dataDict = jsonDict["data"] as? [String: Any],
                                       let token = dataDict["token"] as? String {
                                        if let tokenData = token.data(using: .utf8),
                                           let tokenJSON = try JSONSerialization.jsonObject(with: tokenData, options: []) as? [String: Any],
                                           let userIDString = tokenJSON["id"] as? String,
                                           let userID = Int64(userIDString) {
                                            completion(userID, nil)
                                        } else {
                                            print("Failed to decode token")
                                        }
                                    }
                                } catch {
                                    completion(nil, error)
                                }
                            } else {
                                completion(nil, NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil))
                            }
                        }.resume()
            }
        }
    }

}