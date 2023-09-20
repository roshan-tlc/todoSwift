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
                    if let error = error {
                        completion(.failure(APIService.APIErrors.DECODING_ERROR))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(APIService.APIErrors.INVALID_RESPONSE))
                        return
                    }

                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            do {
                                let projects = try JSONDecoder().decode(ProjectResponse.self, from: data)
                                print("inside", projects)
                                completion(.success(projects.data))
                            } catch {
                                print(error)
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

}

struct ProjectResponse : Decodable {
    let success: Bool
    let message: String
    let data: [APIProject]
}
