//
// Created by Krithik Roshan on 20/09/23.
//

import Foundation

class AdditionalAttributes : Decodable {
    var created_by : String
    var updated_by : String
    var is_deleted : Bool
    var created_at : Int64
    var updated_at : Int64

    init(createdBy: String, updatedBy: String, isDeleted: Bool, createdAt: Int64, updatedAt: Int64) {
        self.created_by = createdBy
        self.updated_by = updatedBy
        self.is_deleted = isDeleted
        self.created_at = createdAt
        self.updated_at = updatedAt
    }
}
