//
// Created by Krithik Roshan on 13/09/23.
//

import Foundation

class Service {

    static let shared = Service()

    private init() {}

    enum APIErrors : Error {
        case INVALID_URL_ERROR
        case INVALID_RESPONSE
    }

}
