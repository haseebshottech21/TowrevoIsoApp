//
//  Constant.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import Foundation
import Device_swift

let APP_DEL = UIApplication.shared.delegate as! AppDelegate

let APP_COLOR = UIColor(red: 0/255, green: 130/255, blue: 242/255, alpha: 1)

let MAIN_STORYBOARD : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let APP_UDS = UserDefaults.standard

let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad ? true : false

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let DEVICE = UIDevice.current.deviceType
let IS_IPHONE = "1"

let MINIMUM_LETTER_FOR_SEARCH = 3
let LOCATION_UPDATE_TIMER_FOR_REPEAT_CALL = Float(3.0)
let LOCATION_UPDATE_TIMER = Float(2.0)
let SEARCH_TEXT_APICALL_HOLD_TIMER = 1.0


let TEXTFIELD_CORNER_RADIUS = CGFloat(3)
let TEXTFIELD_BORDER_WIDTH = CGFloat(1)


let INDECATOR_SIZE = CGSize(width: 50, height: 50)

let GoogleKey = "AIzaSyAQkzNDsWaDJ63wSr_PHE1zEuWrjWTfnTM"

let googleVisionAPI = "https://vision.googleapis.com/v1/images:annotate?key="
let GoogleVisionAPIkey = "AIzaSyAjbwZ4DC41ehI2BU70n3Dr3GNzg88tIc0"
let CUSTOM_URL_SCHEME = "SocialBugbundleIDDL"

let MapBoxPublickKey = "pk.eyJ1Ijoic29jaWFsYnVnIiwiYSI6ImNrY3U4bXhueDF2ZjQycXF6bHltNXprYXMifQ.WYH-dL9IK9qPPAFSqSYA9g" // client key
//pk.eyJ1IjoiYXNoaXNodnJpbiIsImEiOiJjazlpMjRxZGgxMHR3M2Z0YnN6ZGx3d2ttIn0.iBqfyDvg_6lVhabo1eNl4Q // Vrinsoft test


// MARK :- MAP CONSTANTS
let MARKER_HEIGHT_CONSTANT = CGFloat(30.0)
let MARKER_HEIGHT_CONSTANT_NAVIGATION = CGFloat(40.0)


// MARK :- TRIP CONSTANTS
let MINIMUM_TRIP_PLACE_COUNT = 1
let MAXIMUM_TRIP_PLACE_COUNT = 23

// MARK :- OTHER CONSTANTS
let COLLECTION_VIEW_PAGINATION_LOARDER_HEIGHT = CGFloat(50.0)
let GMSServicesApiKey = "AIzaSyDJXaXxSGTPbOThZcYMoOdrgYfOkV57v6Y"

//Post Media : post_media (All post related)
//User Profile Image : profile_images
// Trip Image : trip_image
//Event Images : event_image
//Other Images : other_media

let SCREEN_TITLE_FONT_SIZE = CGFloat(15.0)


//Notification Center
let ENABLE_LOCATION_SCREEN = "ENABLE_LOCATION_SCREEN"
let UPDATE_TRIP_MAP_HOME_SCREEN = "UPDATE_TRIP_MAP_HOME_SCREEN"
let MY_TRIPS_LIST_REFRESH = "MY_TRIPS_LIST_REFRESH"
let MY_HISTORY_TRIPS_LIST_REFRESH = "MY_HISTORY_TRIPS_LIST_REFRESH"
let TRIP_DETAIL_DISMISSED = "TRIP_DETAIL_DISMISSED"
let MANAGE_TRIP_DELETE = "MANAGE_TRIP_DELETE"
let UPDATE_COUNTS_HOME = "UPDATE_COUNTS_HOME"
let GROUPS_LIST_REFRESH = "GROUPS_LIST_REFRESH"



let APP_CONST = Constant.shared


class Constant
{
    private init() { }
    static let shared = Constant()
    
    let currentUser = "currentSocialBugUser"
    let selectedAddress = "selectedAddress"
    
    let apiDateFormate = "yyyy-MM-dd"
    let apiDateFormate_ymdhms = "yyyy-MM-dd HH:mm:ss"
    let appDateFormate = "dd MMM yyyy, hh:mm a"
    let appDateFormateWithoutTime = "dd MMM yyyy"
    let currentChatUser = "currentSocialBugChatUser"
    let apiDateFormate_dMMMathma = "ddMMM yyyy, HH:mm a"
    
    
}

let APP_SCREEN_NAMES = ScreenNames.shared
class ScreenNames
{
    private init() { }
    static let shared = ScreenNames()
    
    
    //Screens name
    
    let MapHomeVC = "MapHomeVC"
    let StartNewTripPopupVC = "StartNewTripPopupVC"
    let LoginVC = "LoginVC"
    let CreateTripFormVC = "CreateTripFormVC"
    let TripDetailVC = "TripDetailVC"
    let TripPlacePopupVC = "TripPlacePopupVC"
    let DetailVC = "DetailVC"
    let MapSearchVC = "MapSearchVC"
    let GeneralPostDetailVC = "GeneralPostDetailVC"
    let TripPostDetailVC = "TripPostDetailVC"
    let EventPostDetailVC = "EventPostDetailVC"
    let CategoryListSelectionVC = "CategoryListSelectionVC"
    let MyTripsVC = "MyTripsVC"
    let MyTripsHistoryVC = "MyTripsHistoryVC"
    let InviteByFriendsVC = "InviteByFriendsVC"
    let PlacesListVC = "PlacesListVC"
    let InviteFriendsVC = "InviteFriendsVC"
    let TripMemberVC = "TripMemberVC"
    let ExplorePhotoVC = "ExplorePhotoVC"
    let ExploreTripVC = "ExploreTripVC"
    let ExploreVideoVC = "ExploreVideoVC"
    let ExploreEventVC = "ExploreEventVC"
    let AllSearchVC = "AllSearchVC"
    let UserSearchVC = "UserSearchVC"
    let GroupSearchVC = "GroupSearchVC"
    let PlacesSearchVC = "PlacesSearchVC"
    let EventsSearchVC = "EventsSearchVC"
    let SearchTabVC = "SearchTabVC"
    let GroupVc = "GroupVc"
    let MenuVC = "MenuVC"
    let LikeVC = "LikeVC"
    let CommentVC = "CommentVC"
    let ListEventVC = "ListEventVC"
    let CalenderVC = "CalenderVC"
    let EventDetailsVC = "EventDetailsVC"
    let GroupDetailVC = "GroupDetailVC"
    let CreateGroupVc = "CreateGroupVc"
    let GroupInfoVC = "GroupInfoVC"
    let MapTypePopupVC = "MapTypePopupVC"
    let SearchPlaceVC = "SearchPlaceVC"
    let SearchLocationVC = "SearchLocationVC"
    let ReportPopupVC = "ReportPopupVC"
    let UserProfileVC = "UserProfileVC"
    let RequestVC = "RequestVC"
    let TripCompletedVC = "TripCompletedVC"
    let ChangePasswordVC = "ChangePasswordVC"
    let BlockedUserVC = "BlockedUserVC"
    let NotificationPreferenceVC = "NotificationPreferenceVC"
    
}

let API_PARAMETER_CONST = ApiTypeParameter.shared
class ApiTypeParameter
{
    private init() { }
    static let shared = ApiTypeParameter()
    
    
    //Follow following
    let TypeFollower = "1"
    let TypeFollowing = "2"
    
    // Trip Type
    
    // User of Trip Type
    
    
}


class Utility:NSObject{
    class func compressImage(sourceImage: UIImage) -> UIImage {
        var actualHeight : CGFloat = sourceImage.size.height
        var actualWidth : CGFloat = sourceImage.size.width
        
        let maxHeight : CGFloat = 500.0
        let maxWidth : CGFloat = 500.0
        
        var currentRatio : CGFloat = actualWidth / actualHeight
        let maxRatio : CGFloat = maxWidth / maxHeight
        let compressionQuality : CGFloat = 0.4
        
        
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if currentRatio < maxRatio {
                //adjust width according to maxHeight
                currentRatio = maxHeight / actualHeight;
                actualWidth = currentRatio * actualWidth;
                actualHeight = maxHeight;
            } else if currentRatio > maxRatio {
                //adjust height according to maxWidth
                currentRatio = maxWidth / actualWidth;
                actualHeight = currentRatio * actualHeight;
                actualWidth = maxWidth;
            } else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let imageRect : CGRect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(imageRect.size)
        sourceImage.draw(in: imageRect)
        
        guard let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return sourceImage}
        
        guard let tempData : Data = newImage.jpegData(compressionQuality: compressionQuality) else { UIGraphicsEndImageContext(); return sourceImage }
        UIGraphicsEndImageContext();
        
        if let finalImage : UIImage = UIImage(data: tempData) {
            return finalImage
        } else {
            return sourceImage
        }
    }
    class func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    class func showDateInAgoForm (date:String, fromFormat: String) -> String{
        let strLocalDate = self.UTCToLocal(date: date, fromFormat: fromFormat, toFormat: fromFormat)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = fromFormat
        if let dt = dateFormatter1.date(from: strLocalDate) {
            if #available(iOS 13.0, *) {
                let difference = dt.distance(to: Date())
                let strDifference = self.timeAgo(Double(difference ))
                return strDifference
            } else {
                // Fallback on earlier versions
                let difference = Date().timeIntervalSince(dt)
                let strDifference = self.timeAgo(Double(difference ))
                return strDifference
            }
        }
        return ""
    }
    
    
    class func optionMenuPost(postID : String ,userID : String ,presentController : UIViewController,completion: @escaping (SheetType?) -> ()){
        let alert = UIAlertController(title: APP_LBL.AlertTitel, message: nil, preferredStyle: .actionSheet)
        
        
        if userID == "\(APP_DEL.currentUser?.user_id ?? "0")" {
            
            let editAlert =  UIAlertAction(title: APP_LBL.edit, style: .default, handler: { (UIAlertAction) in
                completion(.Edit)
            })
            
            alert.addAction(editAlert)
            
            let cancelAlert = UIAlertAction(title: APP_LBL.delete, style: .default, handler: { (UIAlertAction) in
                
                completion(.Delete)
                //                self.DeletePost(postId: self.arrPosts[sender.tag].post_id, index: sender.tag)
            })
            
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            
            alert.addAction(cancelAlert)
            
        }else{
            //            alert.addAction(UIAlertAction(title: APP_LBL.Report_User, style: .default , handler:{ (UIAlertAction)in
            //
            //                let vc = presentController.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
            //                vc.isFromReportUser = true
            //                vc.strPostUserID = userID
            //                presentController.navigationController?.pushViewController(vc, animated: true)
            //
            //            }))
            //
            //            alert.addAction(UIAlertAction(title: APP_LBL.Report_Post, style: .default , handler:{ (UIAlertAction)in
            //
            //                let vc = presentController.storyboard?.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
            //                vc.isFromReportPost = true
            //                vc.strPostId = postID
            //                presentController.navigationController?.pushViewController(vc, animated: true)
            //            }))
            //
            //            alert.addAction(UIAlertAction(title: APP_LBL.Block_User, style: .default , handler:{ (UIAlertAction)in
            //                completion(.Block)
            //
            //            }))
            
        }
        alert.addAction(UIAlertAction(title: APP_LBL.cancel, style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        presentController.present(alert, animated: true, completion: {
            print("Completion Block")
        })
        
        
        
    }
    
    //  local to UTC date
    class func localToUTC(date:String, fromFormat: String, toFormat : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    
    //UTC TO LOCAL
    class func UTCToLocal(date:String, fromFormat: String, toFormat : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    class func timeAgo(_ seconds: Double) -> String {
        if seconds != nil
        {
            let deltaSeconds = seconds
            let deltaMinutes: Double = deltaSeconds / 60.0
            var minutes: Int
            if deltaSeconds < 5 {
                return "Just now"
            } else if deltaSeconds < 60 {
                return String(format: "%.0f seconds ago", deltaSeconds)
            }
            else if deltaSeconds < 120 {
                return "1 minute ago"
            }
            else if deltaMinutes < 60 {
                return String(format: "%.0f minutes ago", deltaMinutes)
            }
            else if deltaMinutes < 120 {
                return "1 hour ago"
            }
            else if deltaMinutes < (24 * 60) {
                minutes = Int(floor(deltaMinutes / 60))
                return "\(minutes) hours ago"
            }
            else if deltaMinutes < (24 * 60 * 2) {
                return "Yesterday"
            }
            else if deltaMinutes < (24 * 60 * 7) {
                minutes = Int(floor(deltaMinutes / (60 * 24)))
                if minutes == 1
                {
                    return "\(minutes) day ago"
                }else{
                    return "\(minutes) days ago"
                }
            }
            else if deltaMinutes < (24 * 60 * 14) {
                return "Last week"
            }
            else if deltaMinutes < (24 * 60 * 31) {
                minutes = Int(floor(deltaMinutes / (60 * 24 * 7)))
                return "\(minutes) weeks ago"
            }
            else if deltaMinutes < (24 * 60 * 61) {
                return "Last month"
            }
            else if deltaMinutes < (24 * 60 * 365.25) {
                minutes = Int(floor(deltaMinutes / (60 * 24 * 30)))
                return "\(minutes) months ago"
            }
            else if deltaMinutes < (24 * 60 * 731) {
                return "Last year"
            }
            
            minutes = Int(floor(deltaMinutes / (60 * 24 * 365)))
            return "\(minutes) years ago"
        }
        return ""
    }
    
    class func hexStringToUIColor (hex : String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func showAlert(strMsg:String){
        
        let alert = UIAlertController.init(title: APP_LBL.AlertTitel, message: strMsg, preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction.init(title: APP_LBL.ok, style: .default) { (_) in
        }
        alert.addAction(ok)
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        }else{
            APP_DEL.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    class func PushViewControllerFrom(parentVC : UIViewController, strName : String) {
        let controller = MAIN_STORYBOARD.instantiateViewController(withIdentifier: strName)
        parentVC.navigationController?.pushViewController(controller, animated: true)
    }
    
    class func Very_Small_size_10() -> CGFloat
    {
        var textfieldConst = CGFloat()
        textfieldConst = 10.0;
        textfieldConst = textfieldConst + INCRESE_FONT_SIZE()
        return textfieldConst
    }
    
    
    class func TextField_Font_size() -> CGFloat
    {
        var textfieldConst = CGFloat()
        textfieldConst = 15.00;
        textfieldConst = textfieldConst + INCRESE_FONT_SIZE()
        return textfieldConst
    }
    
    class func NodataLabelSize() -> CGFloat
    {
        var textfieldConst = CGFloat()
        textfieldConst = 20.00;
        textfieldConst = textfieldConst + INCRESE_FONT_SIZE()
        return textfieldConst
    }
    
    class func Header_Font_size() -> CGFloat
    {
        var textfieldConst = CGFloat()
        textfieldConst = 16.0;
        textfieldConst = textfieldConst + INCRESE_FONT_SIZE()
        return textfieldConst
    }
    
    class func Small_size_12() -> CGFloat
    {
        var textfieldConst = CGFloat()
        textfieldConst = 12.0;
        textfieldConst = textfieldConst + INCRESE_FONT_SIZE()
        return textfieldConst
    }
    
    class func Small_size_14() -> CGFloat
    {
        var textfieldConst = CGFloat()
        textfieldConst = 14.0;
        textfieldConst = textfieldConst + INCRESE_FONT_SIZE()
        return textfieldConst
    }
    
    class func BigLabelSize() -> CGFloat
    {
        var textfieldConst = CGFloat()
        textfieldConst = 30.0;
        textfieldConst = textfieldConst + INCRESE_FONT_SIZE()
        return textfieldConst
    }
    
    class func Button_Font_size() -> CGFloat
    {
        var textfieldConst = CGFloat()
        textfieldConst = 18.00;
        textfieldConst = textfieldConst + INCRESE_FONT_SIZE()
        return textfieldConst
    }
    
    //MARK:- Bold
    class func SetBold(_ size: CGFloat) -> UIFont {
        return UIFont(name:FontName.Bold.rawValue, size: size)!
    }
    
    //MARK:- Regular
    class func SetRagular(_ size: CGFloat) -> UIFont {
        return UIFont(name:FontName.Regular.rawValue, size: size)!
    }
    
    //MARK:- SemiBold
    class func SetSemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name:FontName.SemiBold.rawValue, size: size)!
    }
    
    //MARK:- Heavy
    class func SetHeavy(_ size: CGFloat) -> UIFont {
        return UIFont(name:FontName.Heavy.rawValue, size: size)!
    }
    
    //MARK:- Light
    class func SetLight(_ size: CGFloat) -> UIFont {
        return UIFont(name:FontName.Light.rawValue, size: size)!
    }
    //MARK:- Black
    class func SetBlack(_ size: CGFloat) -> UIFont {
        return UIFont(name:FontName.Black.rawValue, size: size)!
    }
    class func INCRESE_FONT_SIZE() -> CGFloat
    {
        if SCREEN_HEIGHT >= 736 {
            return 1
        }else if SCREEN_HEIGHT >= 667{
            return 0.5
        }else if SCREEN_HEIGHT <= 568 {
            return 0
        }
        return 0
    }
    
    class func Appcolor() -> UIColor{
        return UIColor(red: 58.0/255.0, green: 123.0/255.0, blue: 178.0/255.0, alpha: 1.0)
    }
}
