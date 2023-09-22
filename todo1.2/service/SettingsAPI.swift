//
//  SettingsAPI.swift
//  todo1.2
//
//  Created by Krithik Roshan on 22/09/23.
//

import Foundation

class SettingsAPI : Identifiable {
    
    static let shared = SettingsAPI()
    
    private var interceptor: APIRequestInterceptor?
    
    private init() {}
    
    func get(token: String, completion: @escaping (Result<APISettings, APIService.APIErrors>) -> Void) {
        guard let url = URL(string: DBProperties.baseUrl + "/api/v1/user/system/settings") else {
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
                        let projectResponse = try JSONDecoder().decode(SettingsResponse.self, from: data)
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
}

struct SettingsResponse : Decodable {
    let success: Bool
    let data: APISettings
}
