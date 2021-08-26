//
//  Setting.swift
//  SocialBug
//
//  Created by vishal.n on 30/10/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation

struct SettingModel : Codable {
    
    let code : Int
    let message : String?
    let data : [SettingData]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case data = "data"
    }
}

struct SettingData : Codable {
    
    let id : String?
    var is_post_notification : String?
    var is_follow_notification : String?
    var is_trip_notification : String?
    var is_event_notification : String?
    var is_group_notification : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case is_post_notification = "is_post_notification"
        case is_follow_notification = "is_follow_notification"
        case is_trip_notification = "is_trip_notification"
        case is_event_notification = "is_event_notification"
        case is_group_notification = "is_group_notification"
    }

}
