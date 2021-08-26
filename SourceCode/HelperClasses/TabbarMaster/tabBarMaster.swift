//
//  tabBarMaster.swift
//  SingleltonDemo
//
//  Created by Nick on 20/06/18.
//  Copyright © 2018 Himanshu. All rights reserved.
//

import UIKit

class tabBarMaster: UITabBarController,UITabBarControllerDelegate{
  
    var arrayTabBarVCs = NSMutableArray()
    let menuButton = UIButton(frame: CGRect(x: 0, y: 0 , width: 64, height: 64))
    var lastSelectedIndex = 0
    
    override func viewDidLoad() {
  		      super.viewDidLoad()
    }
    
    //MARK:- TabBarController Add Method
    func add(Controller: UIViewController?, titleTex: String?, normalImage: String?, selectedImage: String?) {
        
        let tabBarVC = tabBO()
        tabBarVC.tabController = Controller!
        tabBarVC.tabTitleText = titleTex!
        tabBarVC.tabNormalImageName = normalImage!
        tabBarVC.tabSelectedImageName = selectedImage!
        self.arrayTabBarVCs.add(tabBarVC)
    }
    
    //MARK:- TabController Index Method
    func tabbarController(indexToSelect:Int?, normalColor:UIColor, selectedColor:UIColor){
        
        var arrayVCS = NSArray()
        arrayVCS = arrayTabBarVCs
        var index: Int = indexToSelect!
        if index >= arrayVCS.count {
            index = 0
        }
        self.tabBar.autoresizesSubviews = true
        self.delegate = self
        self.tabBar.backgroundColor = UIColor.darkGray
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().barTintColor = UIColor.darkGray
        UITabBar.appearance().backgroundColor = UIColor.darkGray
        let arrayNaviViewCs = NSMutableArray()
       //contr
        for controller in arrayVCS {
            
            let conC : tabBO = controller as! tabBO
            let nav = UINavigationController(rootViewController: conC.tabController)
          //  nav.isNavigationBarHidden = true
            arrayNaviViewCs.add(nav)
        }
        
        
                
        self.viewControllers  = NSArray(array: arrayNaviViewCs) as? [UIViewController]

        let tabBar: UITabBar = self.tabBar
        UITabBar.appearance().shadowImage = nil
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.barTintColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
//        tabBar.barTintColor = UIColor.black
       
        for i in 0 ..< tabBar.items!.count {
           
            let tabBarItem: UITabBarItem? = tabBar.items?[i]
            
            let imageNormal = UIImage(named: (arrayTabBarVCs as! [tabBO])[i].tabNormalImageName)?.withRenderingMode(.alwaysOriginal)
            
            let selectedImage = UIImage(named: (arrayTabBarVCs as! [tabBO])[i].tabSelectedImageName)?.withRenderingMode(.alwaysOriginal)
            
            let strTitle : String = (arrayTabBarVCs as! [tabBO])[i].tabTitleText
            
            tabBarItem?.image = imageNormal;
            tabBarItem?.selectedImage = selectedImage
            tabBarItem?.title = strTitle
        
            tabBarItem!.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            tabBarItem?.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)

//            tabBarItem!.imageInsets = UIEdgeInsets(top: 1, left: 2, bottom: 0, right: 2)
//            tabBarItem?.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)

        }
               
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalColor], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)

       
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Utility.SetRagular(12)], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
       

        
        
        if #available(iOS 13.0, *) {
            let win = UIApplication.shared.windows.first
            win?.rootViewController = self
            win?.makeKeyAndVisible()
        }else{
            APP_DEL.window = UIWindow(frame: UIScreen.main.bounds)
            APP_DEL.window?.rootViewController = self
            APP_DEL.window?.makeKeyAndVisible()
        }

            self.selectedIndex = indexToSelect!
        
        view.layoutIfNeeded()

    }
 
    
    
    //MARK:- UITabBarControllerDelegate 
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        if (lastSelectedIndex == 2){
            let controller = (tabBarController.viewControllers![2] as! UINavigationController).viewControllers.first!
            controller.dismiss(animated: false, completion: nil)
        } else if (lastSelectedIndex == 4) {
            let controller = (tabBarController.viewControllers![2] as! UINavigationController).viewControllers.first ?? UIViewController()
            controller.viewWillAppear(true)
        }
        tabBarController.selectedViewController = viewController


    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
           lastSelectedIndex = tabBarController.selectedIndex
//        if (lastSelectedIndex == 2){
//            let controller = (tabBarController.viewControllers![2] as! UINavigationController).viewControllers.first as! MapHomeVC
//            controller.isFromTabChange = true
//        }
           return true;
       }
}

//MARK:- TabBar Variable  Model
class tabBO: NSObject {
 
    var tabController = UIViewController()
    var tabTitleText = ""
    var tabNormalImageName = ""
    var tabSelectedImageName = ""
    var normalColor = UIColor()
    var seletedColor = UIColor()
  
}
