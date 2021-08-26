//
//  NotificationModel.swift
//  SocialBug
//
//  Created by vishal nayee on 22/06/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation




class NotificationModel: Codable
{
    let code : Int
    let message : String?
    let result : [NotificationList]?
    let total_count : Int?
    let friend_request_count : Int?
    let last_follow_requested_img : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case result = "data"
        case total_count = "total_count"
        case friend_request_count = "friend_request_count"
        case last_follow_requested_img = "last_follow_requested_img"

    }
}

struct NotificationList : Codable {
    
    let id : String?
    let desc : String?
    let title : String?
    var type : String?
    var postImg : String?
    var profilePhoto : String?
    var from_id : String?
    var user_id : String?
    var attached_id : String?
    var is_read : String?
    var created_at : String?

    var isLoader : String?
    var is_accept : String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case desc = "description"
        case title = "title"
        case type = "type"
        case postImg = "post_image"
        case profilePhoto = "user_profile_pic"
        case from_id = "from_id"
        case user_id = "user_id"
        case attached_id = "attached_id"
        case is_read = "is_read"
        case created_at = "created_at"
        case isLoader = "isLoader"
        case is_accept = "is_accept_to"

    }
}


/*type
 
 Like post
 Comment post
 Like comment
 Request  received
 Request accepted
 Group Join request
 Group Join request Accepted
 Event Join Request accepted
 Trip Join request*/
