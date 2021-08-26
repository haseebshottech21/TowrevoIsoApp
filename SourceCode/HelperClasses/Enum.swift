//
//  Enum.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit

enum FontName : String {
    
    case Black = "SFProText-Medium"
    case Bold = "SFProText-Bold"
    case Regular = "SFProText-Regular"
    case SemiBold = "SFProText-Semibold"
    case Heavy = "SFProText-Heavy"
    case Light = "SFProText-Light"
    
}

enum CmsType : Int {

    case TermsConditions = 2
    case AboutUs = 1
    case PrivacyPolicy = 3
}

enum UserType : String {
    
    case Company = "2"
    case User = "1"
}

enum FontSize : CGFloat {
    
    case Btn_Default = 23.0
    case Txt_Default = 17.0
}

enum FormType : String {
    
    case Email = "Email"
    case CurrentPassword = "CurrentPassword"
    case NewPassword = "NewPassword"
    case Password = "Password"
    case Confirm_password = "Confirm password"
    case Full_name = "Full name"
    case FirstName = "First Name"
    case LastName = "Last Name"
    case date_of_birth = "Date of birth"
    case room_title = "Room title"
    case StartDate = "Start date"
    case EndDate = "End date"
    
    case MinimumStay = "MinimumStay"
    case MaximumStay = "MaximumStay"
    
    case MonthlyRent = "MonthlyRent"
    case Deposit = "Deposit"

}


enum viewType : Int {

    case Overview = 1
    case Photos = 2
    case Reviews = 3
    case myProfile = 4
    case otherUserProfile = 5
}

enum searchType : Int {

    case All = 1
    case User = 2
    case Groups = 3
    case Places = 4
    case Events = 5
}


enum DocType : String {

    case none = "none"
    
    case DOC = "DOC"
    case PDF = "PDF"
}

enum PostListApiType : String {

    case HomeNewsFeed = "1"
    case UserProfileFeed = "4"
    case GroupDetailFeed = "3"
}


/*So blank => Nothing
0 => Requested
1 => Following*/

enum ReqSendAcceptType : String {
    case requested  = "0"
    case following  = "1"
    case none  = ""
}

struct InvitationStatus {
    var invited : String = "0"
    var member : String = "1"
    var none : String = "2"
    var reject : String = "3"
}

// Explore List Type
enum ExploreListType : String {

    case image = "1"
    case video = "2"
    case trip = "3"
    case event = "4"
}



// Running status of trip
enum TripRunningStatus : String {

    case none = "0"
    case Started = "1"
    case Ended = "2"
}

// Running status of trip
enum PlaceParkingType : String {

    case notAvailable = "1"
    case normalParking = "2"
    case premiumParking = "3"
}

// Place Origin Type
enum PlaceOriginType : String {

    case none = "0"
    case AdminPlace = "1"
    case MapBoxPlace = "2"
}

// Place Origin Type
enum ProfilePrivateType : String {

    case kPublic = "0"
    case kPrivate = "1"
}

// Place Origin Type
enum MapMarkerType : String {

    case none = "0"
    case TripPlace = "1"
    case SearchPlace = "2"
}


enum SheetType : Int{
    case Delete = 1//"Delete"
    case Edit = 2//"Edit"
    case Block = 3//"Block"
}

enum DocExt : String {

    case none = "none"
    
    case DOC = "DOC"
    case doc = "doc"
    case DOCX = "DOCX"
    case docx = "docx"
    
    case PDF = "PDF"
    case pdf = "pdf"
    
    case JPG = "JPG"
    case JPEG = "JPEG"
    case jpg = "jpg"
    case jpeg = "jpeg"
    
    case PNG = "PNG"
    case png = "png"
}

enum Observer : String {

    case messageReload = "messageReload"
    case ReloadConversation = "ReloadConversation"
    case pushNav = "pushNav"
}

enum NotificationType : Int {
    case chatMessage = -10

    case trip_invitation_received = 1
    case trip_invitation_accepted = 2
    case trip_invitation_rejected = 3
    case trip_started = 4
    case trip_report = 5 // Its old report method which is done trip detail now 28 type is done from navigation map
    case trip_ended = 6
    case trip_calloff = 7
    case like_post = 8
    case user_follwing = 9
    case comment_post = 10
    case follow_request_accepted = 11
    case follow_request_received = 12
    case trip_modified = 13
    case group_invite = 14
    case NOTIFICATION_GROUP_INVITE_ACCEPT = 15 // Group detail
    case NOTIFICATION_GROUP_INVITE_REJECT = 16 // Group Detail
    case NOTIFICATION_LEAVE_GROUP = 17 // Group detail
    case NOTIFICATION_EVENT_INVITE_ACCEPT = 18 // Event detail
    case NOTIFICATION_EVENT_INVITE_REJECT = 19 // Event detail
    case event_request = 20
    case NOTIFICATION_GROUP_JOIN_INVITE_ACCEPTED = 21 // Group detail
    case NOTIFICATION_USER_DELETED_THE_TRIP = 22 // None
    case group_invitation = 23
    case NOTIFICATION_USER_ACCEPTED_GROUP_JOIN_INVITE = 24 // Group detail
    case event_invitation = 25
    case NOTIFICATION_EVENT_JOIN_INVITE_ACCEPTED = 26
    case TRIP_REPORT_MAP = 28

//    case like_comment = 3
//    case request_received = 4
//    case group_join_invitation = 6
//    case follwing = 7
//    case event_join_req_accepted = 8
//    case event_join_invitation = 9
//    case trip_jon_request = 10
}

enum groupPrivacyType : String {
    case Private = "1"
    case Public = "2"
}

//enum groupStatus : String  {
//    case none = "2"
//    case member = "1"
//    case NotJoined = ""
//    case Owner
//}


enum MapType : Int {
    case Default  = 1
    case Satelite  = 2
    case Terrain = 3
    case Hybrid  = 4
}

enum PostTypeId : String {
    case General  = "1"
    case Trip  = "2"
    case Event = "3"
}

enum DeepLinkRedirectionType : String {
    case Trip  = "1"
    case Post  = "2"
    case Event = "3"
    case Group = "4"

}

enum FriendListType : String {
    case Trip  = "1"
    case Group  = "2"
    case Event = "3"
}


enum ResponseCodeType : Int {
    case failure  = 0
    case accountInactive  = -4
    case tokenExpired = -6
    case success  = 1
}

enum EventJoinStatusType : String {
    case pendingRequest = "0" // You have received request for join from event
    case member  = "1" // You are member
    case none  = "2" // Nothing means Nothing
    case requestedToJoin = "3" // logged in user requrest in event for being add
    case Owner = "-1" // Owner
}

enum EventUserType : String {
    case MyEvent = "MyEvent"
    case OtherEvent = "OtherEvent"
    case InvitedEvent = "InvitedEvent"
    case Member = "Member"
    case RequestedToJoin = "RequestedToJoin"
}

enum GroupType : String {
    case none = ""
    case MyGroup = "1"
    case JoinedGroup = "2"
    //case OtherGroup = "OtherGroup"
}

enum GroupJoiningStatusType : String {
    case pendingRequest = "0" // You have received request for join from event
    case member  = "1" // You are member
    case none  = "2" // Nothing means Nothing
    case requestedToJoin = "3" // logged in user requrest in event for being add
    case Owner = "-1" // Owner
}


// For request and for cancelling requests
enum RequestListType : String {
    case kFollowRequestList = "1"
    case kEventJoinRequestList = "2"
    case kGroupJoinRequestList = "3"
}

enum HomeSearchType : String {

    case none = ""
    case User = "1"
    case Place = "2"
    case Group = "3"
    case Event = "4"
    case All = "5"
}

enum RequestStatusActions : String {
    case kSendRequest = "1"
    case kCancelSentRequest = "2"
}


enum UserBlockStatus : String {
    case none = "0"
    case blocked  = "1" 

}
