//
// Created by Krithik Roshan on 20/09/23.
//

import Foundation

class TodoAPIService : Identifiable {
    
    static let shared = TodoAPIService()
    
    private var interceptor: APIRequestInterceptor?
    
    private init() {}
    
    func create(name:String, description:String, token:String, projectId:String, completion : @escaping (Bool, Error?) -> Void ) {
        
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/item") else {
            completion(false, APIService.APIErrors.INVALID_URL)
            return
        }
        
        let userData = [
            Properties.name : name,
            Properties.description : description,
            Properties.projectId : projectId
        ]
        print("project", projectId)
        interceptor = APIRequestInterceptor(token: token)
        var request = interceptor?.intercept( URLRequest(url: url)) ??  URLRequest(url: url)
        
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
    
    func getAll(token: String, completion: @escaping (Result<[APITodo], Error>) -> Void) {
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/item") else {
            completion(.failure(APIService.APIErrors.INVALID_URL))
            return
        }
        interceptor = APIRequestInterceptor(token: token)
        var request = interceptor?.intercept( URLRequest(url: url)) ??  URLRequest(url: url)
        request.httpMethod = DBProperties.get
        request.addValue(Properties.applicationJson, forHTTPHeaderField: Properties.contentType)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(APIService.APIErrors.DECODING_ERROR))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIService.APIErrors.INVALID_RESPONSE))
                return
            }
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 304 {
                if let data = data {
                    do {
                        let projects = try JSONDecoder().decode(GetAllTodo.self, from: data)
                        
                        completion(.success(projects.data))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(APIService.APIErrors.INVALID_RESPONSE))
                }
            } else {
                completion(.failure(APIService.APIErrors.INVALID_RESPONSE))
            }
        }.resume()
    }
    
    
    func update(id:String, isCompleted:Bool, token:String, projectId:String, completion : @escaping (Bool, Error?) -> Void ) {
        
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/item" + id) else {
            completion(false, APIService.APIErrors.INVALID_URL)
            return
        }
        
        let userData = [
            Properties.is_completed : isCompleted,
            Properties.projectId : projectId
        ] as [String : Any]
        
        interceptor = APIRequestInterceptor(token: token)
        var request = interceptor?.intercept( URLRequest(url: url)) ??  URLRequest(url: url)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: userData) {
            request.httpMethod = DBProperties.put
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
    
    func get(id: String, token: String, completion: @escaping (Result<APITodo, APIService.APIErrors>) -> Void) {
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/item/" + id) else {
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
                        let projectResponse = try JSONDecoder().decode(GetTodo.self, from: data)
                        completion(.success(projectResponse.data))
                        print("get success", projectResponse)
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
    
    func remove(id:String, token:String, completion : @escaping (Bool, Error?) -> Void) {
        
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/item/" + id) else {
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

struct GetAllTodo : Decodable {
    let success: Bool
    let message: String
    let data: [APITodo]
}

struct GetTodo : Decodable {
    let success: Bool
    let message: String
    let data: APITodo
}
