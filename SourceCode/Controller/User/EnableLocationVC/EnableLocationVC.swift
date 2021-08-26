//
//  EnableLocationVC.swift
//  SocialBug
//
//  Created by Yesha on 15/05/20.
//  Copyright © 2020 Yesha. All rights reserved.
//

import UIKit
import CoreLocation

class EnableLocationVC: UIViewController {
    
    @IBOutlet var scrll: UIScrollView!
    @IBOutlet var vwCenter: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgvLocation: UIImageView!
    @IBOutlet var btnEnable: UIButton!
    @IBOutlet var btnNotNow: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        APP_DEL.isEnableLocationPresented = true
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
//        APP_DEL.isCreateTabBar = true

    }
    
    //MARK:- Setup UI
    func setData(){
        
        lblTitle.text = APP_LBL.let_socialbug_access_your_location
        lblTitle.font = Utility.SetSemiBold(Utility.TextField_Font_size())
        
        btnEnable.setTitle(APP_LBL.enable_location, for: .normal)
        btnEnable.titleLabel?.font = Utility.SetSemiBold(Utility.TextField_Font_size())
        btnNotNow.setTitle(APP_LBL.not_now, for: .normal)
        btnNotNow.titleLabel?.font = Utility.SetSemiBold(Utility.TextField_Font_size())
        
        btnEnable.layer.cornerRadius = btnEnable.frame.size.height/2
        btnEnable.layer.masksToBounds = true
        
        btnEnable.isHidden = true
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                case .restricted, .denied:
                do {
                    btnEnable.setTitle(APP_LBL.enable_location, for: .normal)
                    btnEnable.isHidden = false
                }
                break

             @unknown default:
                do {
                    btnEnable.setTitle(APP_LBL.allow_permission, for: .normal)
                    btnEnable.isHidden = false
                }
                break
            }
        } else {
            btnEnable.setTitle(APP_LBL.enable_location, for: .normal)
            btnEnable.isHidden = false
            print("Location services are not enabled")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        APP_DEL.isEnableLocationPresented = false
    }
    
    //MARK:- Action Methods
    @IBAction func btnEnavleLocationAction(_ sender: Any) {
        if (!APP_DEL.isLocationEnabled){
//            APP_DEL.isCreateTabBar = true
            APP_DEL.initializeLocationServices()
        } else {
            APP_DEL.setTabbar()
        }
    }
    @IBAction func btnNotNowAction(_ sender: Any) {
        APP_DEL.setTabbar()
    }
    
}
