//
//  User.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import Foundation

struct UpdatePictureModel: Codable
{
    let code : Int
    let message : String?
    let result : [UpdatePicture]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case result = "data"
    }
}

struct UpdatePicture: Codable
{
    let profile_image : String?

    enum CodingKeys: String, CodingKey {

        case profile_image = "profile_image"
    }
}

struct UserModel: Codable
{
    let code : Int
    let message : String?
    let data : [User]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case data = "data"
    }
}
struct categoryCompany : Codable {
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
    }
}

struct User: Codable
{
    let user_id : String?
    let first_name : String?
    let last_name : String?
    let company_name : String?
    let working_hour : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let about : String?
    let user_type : String?
    let token : String?
    let mobile : String?
    let email : String?
    let company_profile_image : String?
    let is_verify : String?
    var otp : String?
    let profile_image : String?
    let country_code : String?
    let category : [categoryCompany]?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case company_name = "company_name"
        case working_hour = "working_hour"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case about = "about"
        case user_type = "user_type"
        case token = "token"
        case mobile = "mobile"
        case email = "email"
        case company_profile_image = "company_profile_image"
        case is_verify = "is_verify"
        case otp = "otp"
        case profile_image = "profile_image"
        case category = "category"
        case country_code = "country_code"
        
    }
    
      func syncronize() {
          
          do {
              
              let json : [String : Any] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: []) as! [String : Any]
              APP_UDS.set(json, forKey: APP_CONST.currentUser)
              APP_UDS.synchronize()
              
          } catch {
              print("ERROR.JD")
          }
      }
      
      func logout() {
          
        if let id = APP_DEL.currentUser?.user_id {
//            APP_SCT.emit_offline(parameter: [["id":"\(id)"]]) { }
        }
        
    
        
          print("Logout:- Done")
          APP_DEL.currentUser = nil
          APP_UDS.removeObject(forKey: APP_CONST.currentUser)
          APP_UDS.synchronize()
          APP_DEL.setTabbar()
      }
}

struct UserProfileDataModel: Codable
{
    let code : Int
    let message : String?
    var result : [UserProfileViewData]?
    let friend_request_count : Int?
    let last_follow_requested_img : String?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case result = "data"
        case friend_request_count = "friend_request_count"
        case last_follow_requested_img = "last_follow_requested_img"
    }
}

struct UserProfileViewData : Codable {
    let id : Int?
    var following : String?
    var followers : String?
    var total_post : String?
    let username : String?
    let email : String?
    var profile_image : String?
    var is_account_private : String?
    var is_accept : String?
    var is_block : String?
    var message_id : String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case following = "following"
        case followers = "followers"
        case total_post = "total_post"
        case username = "username"
        case email = "email"
        case profile_image = "profile_image"
        case is_account_private = "is_account_private"
        case is_accept = "is_accept"
        case is_block = "is_block"
        case message_id = "message_id"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        following = try values.decodeIfPresent(String.self, forKey: .following)
        followers = try values.decodeIfPresent(String.self, forKey: .followers)
        total_post = try values.decodeIfPresent(String.self, forKey: .total_post)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        is_account_private = try values.decodeIfPresent(String.self, forKey: .is_account_private)
        is_accept = try values.decodeIfPresent(String.self, forKey: .is_accept)
        is_block = try values.decodeIfPresent(String.self, forKey: .is_block)
        message_id = try values.decodeIfPresent(String.self, forKey: .message_id)

    }

}

struct PlanDetail : Codable {
    
    let plan_id : String?
    let plan_name : String?
    let plan_price : String?
    let plan_type : String?
    let plan_duration : String?
    let plan_start_date : String?
    let plan_end_date : String?
    let total_featured_room : String?
    let total_add_room : String?
    let remain_featured_room : String?
    let remain_add_room : String?

    enum CodingKeys: String, CodingKey {

        case plan_id = "plan_id"
        case plan_name = "plan_name"
        case plan_price = "plan_price"
        case plan_type = "plan_type"
        case plan_duration = "plan_duration"
        case plan_start_date = "plan_start_date"
        case plan_end_date = "plan_end_date"
        case total_featured_room = "total_featured_room"
        case total_add_room = "total_add_room"
        case remain_featured_room = "remain_featured_room"
        case remain_add_room = "remain_add_room"
    }
}




//GENEREL Model
struct CodeModel: Codable
{
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case message = "message"
    }
}

//GENEREL Trip Code Model
struct GeneralTripCodeModel: Codable
{
    let code: Int
    let message: String
    let data : [[String:String]]?
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case message = "message"
        case data = "data"
    }
}


//// Chat Module
//struct ChatUserModel: Codable
//{
//    let code : Int
//    let message : String?
//    let result : [ChatUser]?
//
//    enum CodingKeys: String, CodingKey {
//
//        case code = "code"
//        case message = "message"
//        case result = "result"
//    }
//}
//
//struct ChatUser: Codable
//{
//    let user_id : String?
//    let firstname : String?
//    let lastname : String?
//    let email : String?
//    let token : String?
//    let login_type : String?
//    let dob : String?
//    let moving_room : String?
//    let language : String?
//    let description : String?
//    var profile_image : String?
//
//    func syncronize() {
//
//        do {
//
//            let json : [String : Any] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: []) as! [String : Any]
//            APP_UDS.set(json, forKey: APP_CONST.currentChatUser)
//            APP_UDS.synchronize()
//
//        } catch {
//            print("ERROR.JD")
//        }
//    }
//
//    func logout() {
//
//        print("Logout:- Done")
//        APP_DEL.currentChatUser = nil
//        APP_UDS.removeObject(forKey: APP_CONST.currentChatUser)
//        APP_UDS.synchronize()
//    }
//}


// Chat Module
struct NotificationCountModel: Codable
{
    let code : Int
    let message : String?
    let notification_count : Int?
    let trip_invite_count : Int?
    let group_invite_count : Int?
    let friend_request_count : Int?
    let event_request_count : Int?
    let unread_chat_count : Int?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case notification_count = "notification_count"
        case trip_invite_count = "trip_invite_count"
        case group_invite_count = "group_invite_count"
        case friend_request_count = "friend_request_count"
        case event_request_count = "event_request_count"
        case unread_chat_count = "unread_chat_count"

    }
}
