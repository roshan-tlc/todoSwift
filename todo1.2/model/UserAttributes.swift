//
// Created by Krithik Roshan on 20/09/23.
//

import Foundation

class UserAttributes : Decodable {
    
    var is_deleted : Bool
    var created_at : Int64
    var updated_at : Int64

    init(isDeleted: Bool, createdAt: Int64, updatedAt: Int64) {
        self.is_deleted = isDeleted
        self.created_at = createdAt
        self.updated_at = updatedAt
    }
}
