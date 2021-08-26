//
//  AppDelegate.swift
//  SourceCode
//
//  Created by Jayesh Dabhi on 15/12/20.
//  Copyright © 2020 Technology. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation
import FirebaseCrashlytics
import Firebase
import NVActivityIndicatorView
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabobj : tabBarMaster!
    var currentUser: User?
    var location: CLLocationManager!
    var userCurrentAddress: CLLocationCoordinate2D!
    var locationTimer: Timer?
    var isLocationEnabled = Bool()
    var isEnableLocationPresented = Bool()
    var deviceToken = ""
    var fcmToken = ""
    var isChatOpenId = ""
    var contactNumberAdmin = ""
    var emailAdmin = ""
    var SelectedUserType : UserType?
    var dictNotificationData : NSDictionary?
    var isNotificationReceived = false
    var selectedAddress = Address()
    var updatedAddress = Address()
    var isImageAdded = false
    
//    var static_latitude = "23.1013"
//    var static_longitude = "72.5407"
//    var static_address = "Gota, Ahmedabad, Gujarat 382481"
    
    var activityIndicatorView : NVActivityIndicatorView?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        APP_DEL.deviceToken = "werljewlrjwlerjwlje"
        APP_DEL.fcmToken = "werljewlrjwlerjwlje"
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
           NoNetworkManager.enableLackOfNetworkTakeover()
        //                GMSPlacesClient.provideAPIKey("")
        //                GMSServices.provideAPIKey("")
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = CUSTOM_URL_SCHEME
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width/2) - 25.0, y: (UIScreen.main.bounds.height/2) - 25.0, width: 50.0, height: 50.0), type: .ballPulse, color: APP_COLOR, padding: 0)
        
        
        self.detectPermissionOfLocation()
        
        // to load trip instantly when app start
        //        APP_DEL.isNeedToLoadTrip = true
        //        APP_DEL.loadTripId = "23"
        
       // self.setupPushNotification(application)
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //                API_S3.initializeS3()
        
        //                self.initializeFirebase()
        
        //                APP_SCT.establishConnection() // socket connected
        
        NotificationCenter.default.addObserver(self, selector: #selector(EnableLocationScreen), name: Notification.Name(ENABLE_LOCATION_SCREEN), object: nil)
    
        let vc : SplashVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        if #available(iOS 13.0, *) {
            let win = UIApplication.shared.windows.first
            win?.rootViewController = UINavigationController(rootViewController: vc)
            win?.makeKeyAndVisible()
        } else {
            APP_DEL.window? = UIWindow(frame: UIScreen.main.bounds)
            APP_DEL.window?.rootViewController = UINavigationController(rootViewController: vc)
            APP_DEL.window?.makeKeyAndVisible()
        }
        
        let notificationPayload = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
        if notificationPayload != nil {
            APP_DEL.isNotificationReceived = true
            APP_DEL.dictNotificationData = notificationPayload
        }
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        GMSPlacesClient.provideAPIKey("AIzaSyDJXaXxSGTPbOThZcYMoOdrgYfOkV57v6Y")
        GMSServices.provideAPIKey("AIzaSyDJXaXxSGTPbOThZcYMoOdrgYfOkV57v6Y")
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func detectPermissionOfLocation() {
        if ( CLLocationManager.locationServicesEnabled() ){
            if (CLLocationManager.authorizationStatus() == .authorizedAlways){
                isLocationEnabled = true
            } else if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
                isLocationEnabled = true
            }  else {
                isLocationEnabled = false
            }
        }
    }
    
    @objc func EnableLocationScreen()
    {
        self.detectPermissionOfLocation()
        //        if(window?.rootViewController?.children.count ?? 0 > 1 && window?.rootViewController?.children != nil) {
        //            let viewController = window!.rootViewController!.children[window!.rootViewController!.children.count - 1]
        //
        //            if viewController.isKind(of: EnableLocationVC.self) {
        //                if let url = URL(string: UIApplication.openSettingsURLString) {
        //                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //                }
        //            } else {
        //                APP_DEL.setTabbar()
        //            }
        //        } else {
        //            APP_DEL.setTabbar()
        //        }
        if  isEnableLocationPresented
        {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        } else
        {
            APP_DEL.setTabbar()
        }
    }
    
    @objc func initializeLocationServices() {
        //            LocationService.shared()?.start(withParentView: window?.rootViewController, usageType: kUsageAccessWhileUsingTheApp, accuracy: kLocationAccuracyBestForNavigation, allowBackgroundChanges: true, updateDuration: LOCATION_UPDATE_TIMER, with: { (success, userLocation, trueHeading) in
        //                   if success {
        //    //                self.isLocationEnabled = CLLocationManager.locationServicesEnabled()
        //                    self.detectPermissionOfLocation()
        //
        //
        //    //                   GMSHelper.shared().findAddress(usingLocation: userLocation, withCallBack: { success, addressObject in
        //    //                         self.userCurrentAddress = GMSAddressObject()
        //                    self.userCurrentAddress = userLocation
        //                        if ((self.userCurrentAddress) != nil) {
        //                           if self.userCurrentAddress?.latitude != 0.0000 && self.userCurrentAddress?.longitude != 0.0000 {
        //
        //    //                           LocationService.shared().initializeTimer(afterLocationFetch: true)
        //                            if (self.isCreateTabBar){
        //                                    self.setTabbar()
        //                                    self.isCreateTabBar = false
        //                            }
        //                           }
        //                        }
        //
        //    //                   })
        //                   }
        //               })
        
    }
    
    //MARK:- Location Timer For bak ground
    func UpdateLocationInBackground() {
        locationTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(initializeLocationServices), userInfo: nil, repeats: true)
    }
    
    //MARK:- Check User Login Details
    func isLoggedInUserFound() -> Bool {
        
        if  (APP_UDS.value(forKey: APP_CONST.currentUser) != nil), let dict  = APP_UDS.value(forKey:APP_CONST.currentUser)
        {
            let dictUser : [String : Any] = dict as! [String : Any]
            if let jsonData = try? JSONSerialization.data(withJSONObject: dictUser, options: [.prettyPrinted])
            {
                do
                {
                    let user = try JSONDecoder().decode(User.self, from: jsonData)
                    self.currentUser = user
                    print("CurrentUser:-", dictUser)
                    
                    return true
                } catch {
                    return false
                }
            }
        }
        return false
    }
    
    //MARK:- SetTabbar
    func setTabbar()
    {
        
        if APP_DEL.isLoggedInUserFound() {//&& isLocationEnabled {
            
            if APP_DEL.currentUser?.user_type == UserType.User.rawValue {
                //if APP_DEL.currentUser?.user_type == "user"{
                
                let vc : HomeVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                if #available(iOS 13.0, *) {
                    let win = UIApplication.shared.windows.first
                    win?.rootViewController = UINavigationController(rootViewController: vc)
                    win?.makeKeyAndVisible()
                } else {
                    APP_DEL.window? = UIWindow(frame: UIScreen.main.bounds)
                    APP_DEL.window?.rootViewController = UINavigationController(rootViewController: vc)
                    APP_DEL.window?.makeKeyAndVisible()
                }
            }else if APP_DEL.currentUser?.user_type == UserType.Company.rawValue {
                let vc : CompanyHomeVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyHomeVC") as! CompanyHomeVC
                if #available(iOS 13.0, *) {
                    let win = UIApplication.shared.windows.first
                    win?.rootViewController = UINavigationController(rootViewController: vc)
                    win?.makeKeyAndVisible()
                } else {
                    APP_DEL.window? = UIWindow(frame: UIScreen.main.bounds)
                    APP_DEL.window?.rootViewController = UINavigationController(rootViewController: vc)
                    APP_DEL.window?.makeKeyAndVisible()
                }
            }
        }
        else {
            //                   let vc : LoginVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let vc : CompanyLoginVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyLoginVC") as! CompanyLoginVC
            if #available(iOS 13.0, *) {
                let win = UIApplication.shared.windows.first
                win?.rootViewController = UINavigationController(rootViewController: vc)
                win?.makeKeyAndVisible()
            } else {
                APP_DEL.window? = UIWindow(frame: UIScreen.main.bounds)
                APP_DEL.window?.rootViewController = UINavigationController(rootViewController: vc)
                APP_DEL.window?.makeKeyAndVisible()
            }
        }
        
        APP_DEL.window?.addSubview(activityIndicatorView!)
    }
    
    func application(_ application:UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //Facebook
        return ApplicationDelegate.shared.application(application, open: (url as URL?)!, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
}



extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("#### FCM TOKEN : \(fcmToken)")
        self.fcmToken = fcmToken ?? ""
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // MARK :- PUSH NOTIFICATION
    
    func setupPushNotification(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert , .sound]) { (granted, error) in
                
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                    
                } else  {
                    print(error as Any)
                }
            }
            
        } else {
            
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        
        APP_DEL.deviceToken = token
        print("DEVICE_TOKEN:- ",APP_DEL.deviceToken)
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if (!APP_DEL.isLoggedInUserFound()){
            return
        }
        let dict = notification.request.content.userInfo as? NSDictionary
        self.isNotificationReceived = false
        
        var type = NotificationType.user_follwing
        var attachedId = ""
        if var typeTemp = dict?.value(forKey: "type") as? Int {
            type = NotificationType(rawValue: Int((dict?.value(forKey: "type") as? Int) ?? 0))!
            attachedId = (dict?.value(forKey: "attached_id") as? String) ?? ""
        } else {
            type = NotificationType.chatMessage
        }
        
        if let topVC : UIViewController = UIApplication.topViewController() {
            
            if (type == .chatMessage) { // 3
                
                //                        if topVC.isKind(of: MessageVC.self) {
                ////                            APP_DEL.managePushNavigation(dict: dict!)
                //                            if (isChatOpenId == dict?["message_id"] as? String){
                //                                return;
                //                            } else  {
                //
                //                                APP_DEL.unread_chat_count = dict?["unread_count_global"] as? String ?? ""
                //                                NotificationCenter.default.post(name: NSNotification.Name(UPDATE_COUNTS_HOME), object: nil)
                //                                completionHandler([.alert,.sound,.badge])
                //                            }
                //                        } else {
                //
                //                            APP_DEL.unread_chat_count = dict?["unread_count_global"] as? String ?? ""
                //                            NotificationCenter.default.post(name: NSNotification.Name(UPDATE_COUNTS_HOME), object: nil)
                //                            completionHandler([.alert,.sound,.badge])
                //                        }
                
            } else  {
                completionHandler([.alert,.sound,.badge])
            }
        } else {
            completionHandler([.alert,.sound,.badge])
        }
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let dict = response.notification.request.content.userInfo as? NSDictionary {
            let state = UIApplication.shared.applicationState
            if (state == .inactive && !(APP_DEL.isNotificationReceived)) {
                //                            APP_DEL.isNotificationReceived = true
                //                            AppDelegate.dictNotificationData = dict
                self.managePushNavigation(dict: dict)
            } else if (state == .inactive) {
                APP_DEL.isNotificationReceived = true
                APP_DEL.dictNotificationData = dict
            } else {
                self.managePushNavigation(dict: dict)
                
            }
        }
        //            let dict = response.notification.request.content.userInfo as? NSDictionary
        //            let type = NotifType(rawValue: Int(dict?["notification_type"] as? String ?? "0")!)!
        //
        //            print("didReceive:- ",dict)
        //            print("NOTI_TYPE:- ",type.rawValue)
        //
        //            AppDelegate.dictNotificationData = dict
        //            NotificationCenter.default.post(name: NSNotification.Name(Observer.RefreshHomeVC.rawValue), object: nil)
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]){
        print("Notification data \(userInfo)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //
    //        return true;
    //    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return true;
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            if (error == nil){
                //                print("Dynamic Link : \(dynamiclink?.url?.absoluteString)")
                if let actualURL = dynamiclink?.url {
                    print(actualURL)
                    self.DeeplinkForward(actualURL.absoluteString)
                }
                
            } else {
                print("Dynamic Link ERROR : \(error?.localizedDescription)")
                
            }
        }
        //
        //        return handled
        
        //         URLSession.shared.dataTask(with: userActivity.webpageURL!) { (data, response, error) in
        //
        //            DynamicLinks.performDiagnostics(completion: nil)
        //
        //             if let actualURL = response?.url {
        //                 print(actualURL)
        //                 self.DeeplinkForward(actualURL.absoluteString)
        //
        //             }
        //         }.resume()
        
        return true
    }
    
    
    func DeeplinkForward(_ strDeeplink: String) {
        if (!APP_DEL.isLoggedInUserFound()){
            return
        }
        print(strDeeplink)
        var typeValue = ""
        var idValue = ""
        var postType = ""
        if let arrTemp1 = strDeeplink.components(separatedBy: "?") as? [String]{
            if arrTemp1.count > 1 {
                if let arrTemp2 = (arrTemp1.last ?? "").components(separatedBy: "&") as? [String]{
                    if arrTemp2.count > 0 {
                        var index = 0
                        for str in arrTemp2{
                            
                            if let arrTemp = (str ?? "").components(separatedBy: "=") as? [String]{
                                if index == 0 {
                                    typeValue = arrTemp.last ?? ""
                                } else if index == 1 {
                                    idValue = arrTemp.last ?? ""
                                } else {
                                    postType = arrTemp.last ?? ""
                                }
                            }
                            index = index + 1
                        }
                        if (typeValue != "" && idValue != "") {
                            switch DeepLinkRedirectionType(rawValue: typeValue) {
                            case .Trip:
                                do {
                                    if let topVC : UIViewController = UIApplication.topViewController() {
                                        //                                            if topVC.isKind(of: TripDetailVC.self){
                                        //                                                (topVC as! TripDetailVC).trip_id_to_load = idValue
                                        //                                                topVC.viewDidLoad()
                                        //                                            } else {
                                        //
                                        //                                                tabobj.selectedIndex = 4
                                        //                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        //                                                    let latest_topVC : UIViewController = UIApplication.topViewController()!
                                        //                                                    let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "TripDetailVC") as! TripDetailVC
                                        //                                                    vc.modalPresentationStyle = .overCurrentContext
                                        //                                                    vc.trip_id_to_load = idValue
                                        //                                                    latest_topVC.navigationController?.present(vc, animated: true)
                                        //                                                }
                                        //                                            }
                                    }
                                }
                                break
                                
                            case .Post:
                                do {
                                    if let topVC : UIViewController = UIApplication.topViewController() {
                                        //                                            if topVC.isKind(of: CommentVC.self){
                                        //
                                        //                                                if topVC.isKind(of: CommentVC.self){
                                        //                                                    (topVC as! CommentVC).postIdToLoad = idValue
                                        //                                                    topVC.viewDidLoad()
                                        //                                                }
                                        //                                            } else {
                                        //
                                        //                                                tabobj.selectedIndex = 0
                                        //                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        //                                                    let latest_topVC : UIViewController = UIApplication.topViewController()!
                                        //                                                    let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: APP_SCREEN_NAMES.CommentVC) as! CommentVC
                                        //                                                    vc.postIdToLoad = idValue
                                        //                                                    latest_topVC.navigationController?.pushViewController(vc, animated: true)
                                        //                                                }
                                        //                                            }
                                    }
                                }
                                break
                                
                            case .Event:
                                do {
                                    if let topVC : UIViewController = UIApplication.topViewController() {
                                        //                                            if topVC.isKind(of: EventDetailsVC.self){
                                        //
                                        //                                                if topVC.isKind(of: EventDetailsVC.self){
                                        //                                                    (topVC as! EventDetailsVC).eventIdToLoad = idValue
                                        //                                                    topVC.viewDidLoad()
                                        //                                                }
                                        //                                            } else {
                                        //
                                        //                                                tabobj.selectedIndex = 0
                                        //                                                let latest_topVC : UIViewController = UIApplication.topViewController()!
                                        //                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        //                                                    let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: APP_SCREEN_NAMES.EventDetailsVC) as! EventDetailsVC
                                        //                                                    vc.eventIdToLoad = idValue
                                        //                                                    latest_topVC.navigationController?.pushViewController(vc, animated: true)
                                        //                                                }
                                        //
                                        //                                            }
                                    }
                                }
                                break
                                
                            case .Group:
                                do {
                                    if let topVC : UIViewController = UIApplication.topViewController() {
                                        //                                            if topVC.isKind(of: GroupDetailVC.self){
                                        //
                                        //                                                if topVC.isKind(of: GroupDetailVC.self){
                                        //                                                    (topVC as! GroupDetailVC).groupID = idValue
                                        //                                                    topVC.viewDidLoad()
                                        //                                                }
                                        //                                            } else {
                                        //
                                        //                                                tabobj.selectedIndex = 0
                                        //                                                let latest_topVC : UIViewController = UIApplication.topViewController()!
                                        //                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        //                                                    let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: APP_SCREEN_NAMES.GroupDetailVC) as! GroupDetailVC
                                        //                                                    vc.groupID = idValue
                                        //                                                    latest_topVC.navigationController?.pushViewController(vc, animated: true)
                                        //                                                }
                                        //
                                        //                                            }
                                    }
                                }
                                break
                            case .none:
                                break
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        if let id = APP_DEL.currentUser?.user_id {
            //            APP_SCT.emit_offline(parameter: [["id":"\(id)"]]) { }
        }
        
        //        APP_SCT.closeConnection()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if let id = APP_DEL.currentUser?.user_id {
            //            APP_SCT.emit_online(parameter: [["id":"\(id)"]]) { }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if let id = APP_DEL.currentUser?.user_id {
            //            APP_SCT.emit_offline(parameter: [["id":"\(id)"]]) { }
        }
    }
    
    func managePushNavigation(dict: NSDictionary) {
        print(dict)
        if (!APP_DEL.isLoggedInUserFound()){
            return
        }
        self.isNotificationReceived = false
        
        var type = NotificationType.user_follwing
        var attachedId = ""
        
        if let typeTemp = dict.value(forKey: "type") as? Int { // true if our server push
            type = NotificationType(rawValue: Int(typeTemp))!
            attachedId = (dict.value(forKey: "attached_id") as? String) ?? ""
        } else if let typeTemp1 = dict.value(forKey: "notification_type") as? String { // true if chat/socket push FCM Push
            type = NotificationType(rawValue: Int(typeTemp1) ?? 0)!
            if type == .TRIP_REPORT_MAP {
                attachedId = (dict.value(forKey: "attached_id") as? String) ?? ""
            } else {
                type = NotificationType.chatMessage
            }
        } else {
            return
        }
        
        if let topVC : UIViewController = UIApplication.topViewController() {
            
            switch type {
                
            case .trip_invitation_received, .trip_invitation_accepted, .trip_invitation_rejected, .trip_ended, .trip_modified, .trip_calloff, .trip_report, .trip_started, .TRIP_REPORT_MAP:
                
                //                        if topVC.isKind(of: TripDetailVC.self){
                ////                            let latest_topVC : UIViewController = UIApplication.topViewController()!
                ////                             let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "TripDetailVC") as! TripDetailVC
                ////                            vc.modalPresentationStyle = .overCurrentContext
                ////                            vc.trip_id_to_load = attachedId
                ////                            latest_topVC.navigationController?.present(vc, animated: true)
                //                            (topVC as! TripDetailVC).trip_id_to_load = attachedId
                //                            topVC.viewDidLoad()
                //                        } else {
                //
                //                            tabobj.selectedIndex = 4
                //                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //                                let latest_topVC : UIViewController = UIApplication.topViewController()!
                //                                let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "TripDetailVC") as! TripDetailVC
                //                                vc.modalPresentationStyle = .overCurrentContext
                //                                vc.trip_id_to_load = attachedId
                //                                latest_topVC.navigationController?.present(vc, animated: true)
                //                            }
                //                        }
                
                break
                
                
            case .NOTIFICATION_USER_DELETED_THE_TRIP:
                break
                
            default:
                break
            }
            
        } else {
            return
        }
        
    }
    
}
