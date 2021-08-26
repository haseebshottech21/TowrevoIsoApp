//
//  CmsVC.swift
//  Comooder
//
//  Created by Vrinsoft on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import WebKit

class CmsVC: BaseVC {

    
    @IBOutlet weak var btnback: UIButton!

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var webview: WKWebView!
    var strTitel = String()
    var cmsType : CmsType?
    var cms : Cms?
    
    //@IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //lbltitle.text = "About Us"
        lbltitle.font = Utility.SetSemiBold(Utility.Header_Font_size())
        lbltitle.textColor = APP_COL.APP_Black_Color
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lbltitle.text = strTitel
               
               self.setUI()
               self.getCms()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    @IBAction func actionBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Set UI Data
    func setUI() {
        self.showProgressHUD()
              var cmsTitle = ""
              if self.cmsType == .AboutUs {
                cmsTitle = APP_LBL.about_us
              } else if self.cmsType == .TermsConditions {
                  cmsTitle = APP_LBL.terms_conditions
              }else if self.cmsType == .PrivacyPolicy {
                cmsTitle = APP_LBL.privacy_policy
              }

        lbltitle.text = cmsTitle
    }
    
    func getCms() {
        
        if self.cmsType != nil {
            let par : [String : String] = [
                "user_id" : APP_DEL.currentUser!.user_id!,
                "user_type" : APP_DEL.currentUser!.user_type!,
                "cms_id" : "\(cmsType!.rawValue)",
                "token" : APP_DEL.currentUser!.token!,
            ]
            self.showProgressHUD()
            API.cms(param: par) { (cms, err) in

                if err == nil {

                    self.cms = cms
                    self.manageContent()
                } else {

                    self.showAlert(message: err ?? "")
                }
                self.hideProgressHUD()
            }
        }
    }
    
    func manageContent() {
        self.hideProgressHUD()
        let content = self.cms?.description ?? lbltitle.text
        
//        let fontName = FontName.Regular.rawValue
       // let fontSize = 14.0
//        let fontSetting = "<span style=\"font-family: \(fontName)\"</span>"
        
      //  let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        
      //   self.webview.loadHTMLString( fontSetting + content, baseURL: nil)
        self.webview.loadHTMLString(content!.stringByDecodingHTMLEntities , baseURL: nil)
        
    }
}
//{
//    self.StopLoader()
//
//    let fontName = FontName.Regular.rawValue
//    let fontSize = 45
//    let fontSetting = "<span style=\"font-family: \(fontName);font-size: \(fontSize)\"</span>"
//
//    let str : String = response?.content ?? ""
//    self.webView.loadHTMLString(fontSetting + (str.stringByDecodingHTMLEntities), baseURL: nil)
//}
