//
//  SceneDelegate.swift
//  SocialBug
//
//  Created by Yesha on 11/05/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseDynamicLinks



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first {
                       self.scene(scene, continue: userActivity)
               }
        
        //MARK:- PLEASE DO NOT REMOVE FOR IOS 13.0, ITS REFERENCE WINDOW FOR SCENE DELEGATE
        APP_DEL.window = self.window
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


    @available(iOS 13.0, *)
      func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
          //first launch after install
        guard let url = URLContexts.first?.url else {
               return
           }

           ApplicationDelegate.shared.application(
               UIApplication.shared,
               open: url,
               sourceApplication: nil,
               annotation: [UIApplication.OpenURLOptionsKey.annotation]
           )
       
      }
      
      @available(iOS 13.0, *)
      func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
       
                 
      }
      
      @available(iOS 13.0, *)
      func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
          //when in background mode
          URLSession.shared.dataTask(with: userActivity.webpageURL!) { (data, response, error) in

                    if let actualURL = response?.url {
                        print(actualURL)
                        APP_DEL.DeeplinkForward(actualURL.absoluteString)
                        
                    }
                }.resume()

      }
    
}

