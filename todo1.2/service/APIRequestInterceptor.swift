//
// Created by Krithik Roshan on 19/09/23.
//

import Foundation
import Alamofire

class APIRequestInterceptor: ObservableObject, RequestInterceptor {

    private let token:String

    init(token:String) {
        self.token = token
    }
    func intercept(_ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.setValue("\(DBProperties.bearer) \(token)", forHTTPHeaderField: Properties.authorization)
        return modifiedRequest
    }
}
