//
// Created by Krithik Roshan on 20/09/23.
//

import Foundation

class ProjectAPIService : Identifiable {
    
    static let shared = ProjectAPIService()
    
    private var interceptor: APIRequestInterceptor?
    
    private init() {}
    
    func create(name:String, description:String, token:String, completion : @escaping (Bool, Error?) -> Void ) {
        
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/project") else {
            completion(false, APIService.APIErrors.INVALID_URL)
            return
        }
        
        let userData = [
            Properties.name: name,
            Properties.description: description
        ]
        
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
    
    func getAllProjects(token: String, completion: @escaping (Result<[APIProject], Error>) -> Void) {
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/project") else {
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
                        let projects = try JSONDecoder().decode(GetAllProjectResponse.self, from: data)
                        completion(.success(projects.data))
                    } catch {
                        print("Error -> ", error)
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
    
    func get(id: String, token: String, completion: @escaping (Result<APIProject, APIService.APIErrors>) -> Void) {
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/project/" + id) else {
            completion(.failure(.INVALID_URL))
            return
        }
        
        let interceptor = APIRequestInterceptor(token: token)
        var request = interceptor.intercept(URLRequest(url: url))
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
                        let projectResponse = try JSONDecoder().decode(GetProjectResponse.self, from: data)
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

    func updatePosition(id:String, token:String,  todos:[APIProject], completion:@escaping (Error?) -> Void) {
        guard let url = URL(string:"\(DBProperties.baseUrl)/api/v1/project/\(id)") else {
            completion(APIService.APIErrors.INVALID_URL)
            return
        }

        let interceptor = APIRequestInterceptor(token:token)
        var request = interceptor.intercept(URLRequest(url:url))
        request.httpMethod = DBProperties.put
        request.addValue(Properties.applicationJson, forHTTPHeaderField: Properties.contentType)

        do {
            let jsonData = try JSONEncoder().encode(todos)
            request.httpBody = jsonData
        } catch {
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error  {
                completion(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(APIService.APIErrors.INVALID_RESPONSE)
                return
            }

            if httpResponse.statusCode == 200 {
                completion(nil)
            } else {
                completion(APIService.APIErrors.INVALID_RESPONSE)
            }
        } .resume()
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

struct GetAllProjectResponse : Decodable {
    let success: Bool
    let message: String
    let data: [APIProject]
}

struct GetProjectResponse : Decodable {
    let success: Bool
    let message: String
    let data: APIProject
}
