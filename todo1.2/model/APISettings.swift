//
// Created by Krithik Roshan on 22/09/23.
//

import Foundation

class APISettings : Decodable {

    var additional_attributes : SettingsAttributes
    var _id : String
    var userId : String
    var font_family : String
    var font_size : CGFloat
    var color : String
    var id : String {
        return _id
    }

    init()
    {
        additional_attributes = SettingsAttributes()
        _id = ""
        userId = ""
        font_family = ""
        font_size = 0
        color = ""

    }

    init(additional_attributes: UserAttributes, id: String, userId: String, fontFamily: String, fontSize: CGFloat, color:String) {
        self.additional_attributes = SettingsAttributes()
        _id = id
        self.userId = userId
        font_family = fontFamily
        font_size = fontSize
        self.color = color
    }
}

struct SettingsAttributes : Decodable {

    var created_at: Int64
    var updated_at: Int64
    var is_deleted : Bool

    init(createdBy: Int64 , updatedAt: Int64, isDeleted: Bool) {
        created_at = createdBy
        updated_at = updatedAt
        is_deleted = isDeleted
    }

    init() {
        created_at = 0
        updated_at = 0
        is_deleted = false
    }
}
