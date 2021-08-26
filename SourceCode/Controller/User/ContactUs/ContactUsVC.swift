//
//  ContactUsVC.swift
//  SourceCode
//
//  Created by Yesha on 20/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class ContactUsVC: BaseVC {
    
    @IBOutlet weak var btnback: UIButton!
    
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var lbltxtcall: UILabel!
    
    @IBOutlet weak var btnCall: UIButton!
    
    
    @IBOutlet weak var lbltxtemail: UILabel!
    
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet var vwMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbltitle.text = APP_LBL.contact_us
        lbltitle.font = Utility.SetSemiBold(Utility.Header_Font_size())
        lbltitle.textColor = APP_COL.APP_Black_Color
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lbltxtcall.text = APP_LBL.call_us
        lbltxtcall.font = Utility.SetSemiBold(Utility.Header_Font_size() + 2)
        lbltxtcall.textColor = APP_COL.APP_DarkGrey_Color
        
        self.btnCall.setTitle(APP_DEL.contactNumberAdmin, for: .normal)
        self.btnEmail.setTitle(APP_DEL.emailAdmin, for: .normal)
        
        btnCall.setTitleColor(APP_COL.APP_Color, for: .normal)
        btnCall.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        
        lbltxtemail.text = APP_LBL.mail_us
        lbltxtemail.font = Utility.SetSemiBold(Utility.Header_Font_size() + 2)
        lbltxtemail.textColor = APP_COL.APP_DarkGrey_Color
        
        
        btnEmail.setTitleColor(APP_COL.APP_Color, for: .normal)
        btnEmail.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        API.settings(param: [:]) { (res, mes) in
            if  mes == nil{
                
                APP_DEL.contactNumberAdmin = res!.mobile!
                APP_DEL.emailAdmin = res!.email!
                self.btnCall.setTitle(APP_DEL.contactNumberAdmin, for: .normal)
                self.btnEmail.setTitle(APP_DEL.emailAdmin, for: .normal)
            } else
            {
                
            }
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnCallAction(_ sender: Any) {
        guard let number = URL(string: "tel://" + APP_DEL.contactNumberAdmin) else { return }
        UIApplication.shared.open(number)
        
        if let url = NSURL(string: "tel://" + APP_DEL.contactNumberAdmin), UIApplication.shared.canOpenURL(url as URL) {
            
            UIApplication.shared.openURL(url as URL)
        }else
        {
            showAlert(message: "Invalid number")
        }
    }
    
    
    @IBAction func btnEmailAction(_ sender: Any) {
        let email = APP_DEL.emailAdmin
        if let url = URL(string: "mailto:\(email ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
