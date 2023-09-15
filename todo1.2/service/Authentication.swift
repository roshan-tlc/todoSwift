//
// Created by Krithik Roshan on 13/09/23.
//

import Foundation


class Authentication: ObservableObject {

    static let shared = Authentication()

    private init() {
    }

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
                                    completion(false, Service.APIErrors.INVALID_RESPONSE)
                                }
                            } else if let error = error {
                                completion(false, error)
                            }
                        }
                        .resume()
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Bool , Error?) -> Void) {

        guard let url = URL(string: "http://localhost:8080/api/v1/user/login") else {
            completion(false, Service.APIErrors.INVALID_URL_ERROR)
            return
        }

        let credentials = ["email": email, "password": password]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: credentials)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    completion(false, error)
                    return
                }

                guard let data = data else {
                    completion(false, nil)
                    return
                }
                do {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            completion(true, nil)
                        } else {
                            completion(false, nil)
                        }
                    }
                } catch {
                    completion(false, error)
                }
            }
            task.resume()
        } catch {
            completion(false, error)
        }
    }

    func forgotPassword(email:String, password:String, oldHint:String, newHint: String, completion : @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "http://localhost:8080/api/v1/user/reset/password")  else {
            completion(false, Service.APIErrors.INVALID_URL_ERROR)
            return
        }

        let credential = ["email":email, "password": password, "oldHint":oldHint, "newHint": newHint]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: credential)

            var request =  URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "content-type")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(false, error)
                }

                guard let data = data else {
                    completion(false, nil)
                    return
                }

                do {
                    if let httResponse = response as? HTTPURLResponse {
                        if httResponse.statusCode == 200 {
                            completion(true, nil)
                        } else {
                            completion(false, nil)
                        }
                    }
                } catch {
                    completion(false, error)
                }
            }
            task.resume()
        } catch {
            completion(false, Service.APIErrors.INVALID_RESPONSE)
        }

    }
}