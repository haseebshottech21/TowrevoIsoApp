//
//  Project.swift
//  Taylors
//
//  Created by Jayesh Dabhi on 27/11/19.
//  Copyright © 2019 Jayesh Dabhi. All rights reserved.
//

import Foundation


struct NotificModel : Codable {

    let code : Int
    let message : String?
    let total_count : String?
    let result : [Notific]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case total_count = "total_count"
        case result = "result"
    }
}

struct Notific : Codable {

    let notification_id : String?
    let user_id : String?
    let notification_type : String?
    let title : String?
    let message : String?
    let create_date : String?
    var is_read : String?

    enum CodingKeys: String, CodingKey {

        case notification_id = "notification_id"
        case user_id = "user_id"
        case notification_type = "notification_type"
        case title = "title"
        case message = "message"
        case create_date = "create_date"
        case is_read = "is_read"
    }
}

struct NotificCountModel : Codable {

    let code : Int
    let message : String?
    let unread_count : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case unread_count = "unread_count"
    }
}

