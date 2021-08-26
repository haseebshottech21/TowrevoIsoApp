//
//  SplashVC.swift
//  Tappoo
//
//  Created by Ashish on 28/01/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        APP_DEL.initializeLocationServices()
//        if APP_DEL.isLocationEnabled {
//            APP_DEL.setTabbar()
//        }
        API.settings(param: [:]) { (res, mes) in
            if  mes == nil{
                APP_DEL.contactNumberAdmin = res!.mobile!
                APP_DEL.emailAdmin = res!.email!
            } else
            {
                
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        
        API.label { (success, msg) in
            if success{
                print("LBL : DONE")
                APP_DEL.setTabbar()
            }else{
                print("LBL : ",msg ?? "")
            }
//            APP_DEL.initializeLocationServices()
            APP_DEL.setTabbar()

        }
        
     
    }
}
