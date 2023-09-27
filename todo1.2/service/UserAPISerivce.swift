//
// Created by Krithik Roshan on 20/09/23.
//

import Foundation

class UserAPIService : Identifiable {
    
    static let shared = UserAPIService()
    
    private var interceptor: APIRequestInterceptor?
    
    private init() {}
    
    func get(token: String, completion: @escaping (Result<APIUser, APIService.APIErrors>) -> Void) {
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/user/details") else {
            completion(.failure(.INVALID_URL))
            return
        }
        
        interceptor = APIRequestInterceptor(token: token)
        var request = interceptor?.intercept(URLRequest(url: url)) ?? URLRequest(url: url)
        request.httpMethod = DBProperties.get
        request.addValue(Properties.applicationJson, forHTTPHeaderField: Properties.contentType)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.DECODING_ERROR))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.INVALID_RESPONSE))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                if let data = data {
                    do {
                        let projectResponse = try JSONDecoder().decode(GetUserResponse.self, from: data)
                        completion(.success(projectResponse.data))
                    } catch {
                        completion(.failure(.DECODING_ERROR))
                    }
                } else {
                    completion(.failure(.INVALID_RESPONSE))
                }
            default:
                completion(.failure(.INVALID_RESPONSE))
            }
        }.resume()
    }

    func update(name: String, title: String, token: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/user/details") else {
            completion(false, APIService.APIErrors.INVALID_URL)
            return
        }

        let interceptor = APIRequestInterceptor(token: token)
        var request = interceptor.intercept(URLRequest(url: url))
        request.httpMethod = DBProperties.put
        request.addValue(Properties.applicationJson, forHTTPHeaderField: Properties.contentType)

        let userData = [
            Properties.name: name,
            Properties.title: title,
        ]
            let data = try! JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)

            URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(true, error)
                    } else {
                        completion(false, APIService.APIErrors.INVALID_RESPONSE)
                    }
                } else if let error = error {
                    completion(false, error)
                }
            }.resume()
    }

    
    
    func remove(id:String, token:String, completion : @escaping (Bool, Error?) -> Void) {
        
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/project/" + id) else {
            completion(false, APIService.APIErrors.INVALID_URL)
            return
        }
        
        interceptor = APIRequestInterceptor(token: token)
        var request = interceptor?.intercept( URLRequest(url: url)) ??  URLRequest(url: url)
        request.httpMethod = DBProperties.remove
        request.addValue(Properties.applicationJson, forHTTPHeaderField: Properties.contentType)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, APIService.APIErrors.INVALID_RESPONSE)
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(true, nil)
            } else {
                completion(false, APIService.APIErrors.INVALID_RESPONSE)
            }
        }.resume()
    }
    
}

struct GetUserResponse : Decodable {
    let success: Bool
    let data: APIUser
}
