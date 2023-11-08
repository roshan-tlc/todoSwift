//
// Created by Krithik Roshan on 13/09/23.
//

import Foundation

class APIService {

    static let shared = APIService()

    private init() {}

    enum APIErrors : Error {
        case INVALID_URL
        case INVALID_RESPONSE
        case DECODING_ERROR
    }

}