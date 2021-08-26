//
//  SideMenuVC.swift
//  SourceCode
//
//  Created by Yesha on 19/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var btnclose: UIButton!
    @IBOutlet var lblCopyRight: UILabel!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var btnTermCondition: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet var lblVersion: UILabel!
    @IBOutlet weak var tblmenu: UITableView!
    
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    
    @IBOutlet weak var tblheightconstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingView: NSLayoutConstraint!

    @IBOutlet weak var btnedit: UIButton!
    
    var arrMenuData : [String] = []
    
//    var arrmenuitem = ["Change Password", "My Inquiries","About Us","Terms & Conditions","Privacy Policy","Contact Us","FAQs"]
//    var arrmenuitemcompany = ["Change Password", "Inquiries Management","About Us","Terms & Conditions","Privacy Policy","Contact Us","FAQs"]
    var parentVc : UIViewController?
    
//    var user = "customer@gmail.com"
//    var com = "company@gmail.com"
    
    //let email = APP_UDS.string(forKey: "useremail")
    override func viewDidLoad() {
        super.viewDidLoad()
        leadingView.constant = -(SCREEN_WIDTH)
        SetUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        ViewProfileAPI()
    }
    func SetUI()
    {
        if (APP_DEL.currentUser?.user_type == UserType.User.rawValue){
                 arrMenuData.removeAll()
                 arrMenuData = [APP_LBL.change_password, APP_LBL.my_inquiries, APP_LBL.about_us_small,APP_LBL.contact_us,APP_LBL.faq]
                 lblname.text = APP_DEL.currentUser!.first_name! + " " + APP_DEL.currentUser!.last_name!
             }else if (APP_DEL.currentUser?.user_type == UserType.Company.rawValue) {
                  arrMenuData.removeAll()
                 arrMenuData = [APP_LBL.change_password,APP_LBL.inquiry_management,APP_LBL.about_us_small,APP_LBL.contact_us,APP_LBL.faq]
                 lblname.text = APP_DEL.currentUser!.company_name!

             }
             //btnclose.backgroundColor = UIColor(white: 0, alpha: 0.5)
             //btnclose.backgroundColor = UIColor.clear
             // Do any additional setup after loading the view.
             
             self.view.layoutIfNeeded()
             btnLogOut.setTitle(title: APP_LBL.logout)
             btnLogOut.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
             btnLogOut.setTitleColor(APP_COL.APP_White_Color, for: .normal)
             btnLogOut.backgroundColor = APP_COL.APP_Color
             btnLogOut.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
             btnLogOut.layer.shadowOffset = CGSize.zero
             btnLogOut.layer.shadowOpacity = 0.5
             btnLogOut.layer.shadowRadius = 10.0
             btnLogOut.layer.masksToBounds = false
             btnLogOut.roundCorner(value: 4.0)
        
        
            btnTermCondition.setTitle(title: APP_LBL.terms_conditions)
            btnPrivacyPolicy.setTitle(title: APP_LBL.privacy_policy)
        
        
             lblVersion.font = Utility.SetRagular(Utility.Small_size_12())
             lblVersion.text = APP_LBL.version + " " + (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
             lblVersion.textColor = APP_COL.APP_Black_Color
        
             lblCopyRight.font = Utility.SetRagular(Utility.Small_size_12())
             lblCopyRight.text = APP_LBL.copyright
             lblCopyRight.textColor = APP_COL.APP_Black_Color
        
        
//        lblCopyRight.font = Utility.SetRagular(Utility.Small_size_12())
//        lblCopyRight.text = APP_LBL.copyright
//        lblCopyRight.textColor = APP_COL.APP_Black_Color
             
             tblmenu.register(UINib(nibName: "SideMenuTableCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableCell")
             tblmenu.delegate = self
             tblmenu.dataSource = self
             tblmenu.reloadData()

             tblheightconstraint.constant = tblmenu.contentSize.height
             
             self.tblmenu.separatorStyle = .none
              if (APP_DEL.currentUser?.user_type == UserType.User.rawValue){
             if let imgUrl = APP_DEL.currentUser!.profile_image {
                 
                 imgprofile.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.user_placeholder), options: .refreshCached) { (img, err, _, _) in
                     //self.imgLogo.contentMode = .scaleAspectFill
                 }
             }
             } else {
             if let imgUrl = APP_DEL.currentUser!.company_profile_image {
                 
                 imgprofile.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.user_placeholder), options: .refreshCached) { (img, err, _, _) in
                     //self.imgLogo.contentMode = .scaleAspectFill
                 }
             }
             }
             imgprofile.rounded()
             
             lblname.font = Utility.SetSemiBold(Utility.Button_Font_size() + 2)
             lblname.textColor = APP_COL.APP_White_Color
             
             
             lblemail.font = Utility.SetRagular(Utility.Small_size_14())
             lblemail.textColor = APP_COL.APP_Faded_White
             lblemail.text = APP_DEL.currentUser!.email!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leadingView.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func ViewProfileAPI()
    {
                  
                  let par : [String : String] = [
                      "user_id" : APP_DEL.currentUser!.user_id!,
                      "token" : APP_DEL.currentUser!.token!,
                      "device_token" : APP_DEL.deviceToken,
                      "user_type" : APP_DEL.currentUser!.user_type!,
                      "device_type" : "1"
                  ]

                  API.viewProfile(param: par) { (user, mess) in

                      if mess == nil {

                          APP_DEL.currentUser = user
                          APP_DEL.currentUser?.syncronize()
                        self.SetUI()
                      } else if mess == "Inactive User"
                      {
                          APP_DEL.currentUser = user
                      }
                        else {

                          self.showAlert(message: mess ?? "")
                      }
                  }
    }
    
    
    
    
    @IBAction func btnEditAction(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)

        if APP_DEL.currentUser?.user_type == UserType.User.rawValue {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC1") as! EditProfileVC1
            parentVc?.navigationController?.pushViewController(vc, animated: false)
        }else if APP_DEL.currentUser?.user_type == UserType.Company.rawValue  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyEditProfileVC") as! CompanyEditProfileVC
            parentVc?.navigationController?.pushViewController(vc, animated: false)
        }
        
        
        
    }
    
    
    @IBAction func btnTermAction(_ sender: UIButton) {
        
//        self.navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: false, completion: nil)
        let tvc = self.storyboard?.instantiateViewController(withIdentifier: "CmsVC") as! CmsVC
        //faqvc.strTitel = "FAQs"
        tvc.cmsType = .TermsConditions
        self.parentVc?.navigationController?.pushViewController(tvc, animated: true)

        
    }
    
    
    @IBAction func btnPrivacyAction(_ sender: UIButton) {
            
    //        self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: false, completion: nil)
            let ppvc = self.storyboard?.instantiateViewController(withIdentifier: "CmsVC") as! CmsVC
            //faqvc.strTitel = "FAQs"
            ppvc.cmsType = .PrivacyPolicy
            self.parentVc?.navigationController?.pushViewController(ppvc, animated: true)
        }
    
    
    
    
    @IBAction func btnLogOutAction(_ sender: Any) {
        
        
        let alert = UIAlertController(title: APP_LBL.AlertTitel, message: APP_LBL.are_you_sure_you_want_to_logout, preferredStyle: .alert)
        let cancel = UIAlertAction(title: APP_LBL.no, style: .destructive) { (can) in
            
        }
        let yes = UIAlertAction(title: APP_LBL.yes, style: .default) { (yes) in
            
            DispatchQueue.main.async {
                
                self.showProgressHUD()
                let par : [String : String] = [
                    "user_id" : APP_DEL.currentUser!.user_id!,
                    "user_type" : APP_DEL.currentUser!.user_type!,
                    "token" : APP_DEL.currentUser!.token!,
                    "device_type" : "1"
                ]
                API.logoutAPI(param: par, completion: { (responce, msg) in
                    if msg == nil {
                        
                        APP_DEL.currentUser?.logout()
                        APP_DEL.setTabbar()
                        self.showAlert(message: APP_LBL.you_are_successfully_logged_out)
                        
                    }
                    self.hideProgressHUD()
                })
               
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(yes)
    self.present(alert, animated: true) {
        
    }
        
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return arrMenuData.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableCell", for: indexPath) as! SideMenuTableCell
        
        cell.selectionStyle = .none
        cell.lbltitle.font = Utility.SetRagular(Utility.Small_size_14())
        cell.lbltitle.text = arrMenuData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45.0)
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        DispatchQueue.main.async {
            
        
        if (indexPath.row == 0) {
            self.dismiss(animated: false, completion: nil)
            if APP_DEL.currentUser!.user_type! == UserType.User.rawValue {
                let cvc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                self.parentVc?.navigationController?.pushViewController(cvc, animated: true)
            }else if APP_DEL.currentUser!.user_type! == UserType.Company.rawValue {
                let cvc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                self.parentVc?.navigationController?.pushViewController(cvc, animated: true)
            }
       }
        else if (indexPath.row == 1){
            self.dismiss(animated: false, completion: nil)
            if APP_DEL.currentUser!.user_type! == UserType.User.rawValue {
                
                let ivc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "MyInquiriesVC") as! MyInquiriesVC
                self.parentVc?.navigationController?.pushViewController(ivc, animated: true)
            
            }else if APP_DEL.currentUser!.user_type! == UserType.Company.rawValue {
                
                self.dismiss(animated: false, completion: nil)
                
            }
        }
        else if (indexPath.row == 2){
            self.dismiss(animated: false, completion: nil)
            let abvc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CmsVC") as! CmsVC
            abvc.strTitel = APP_LBL.about_us
            abvc.cmsType = .AboutUs
            self.parentVc?.navigationController?.pushViewController(abvc, animated: true)
        }
        else if (indexPath.row == 3){
            self.dismiss(animated: false, completion: nil)
            self.dismiss(animated: false, completion: nil)
            let convc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.parentVc?.navigationController?.pushViewController(convc, animated: true)
        }
        else if (indexPath.row == 4){
            self.dismiss(animated: false, completion: nil)
            let faqvc = self.storyboard?.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
            //faqvc.strTitel = "FAQs"
            self.parentVc?.navigationController?.pushViewController(faqvc, animated: true)
            //moveToNextScreen(ViewController: "CmsVC")
        }
        }
    }
}

        
//        else if (indexPath.row == 7){
//            self.dismiss(animated: false, completion: nil)
//            let tcvc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CmsVC") as! CmsVC
//            tcvc.strTitel = APP_LBL.terms_conditions
//            tcvc.cmsType = .TermsConditions
//            self.parentVc?.navigationController?.pushViewController(tcvc, animated: true)
//        }
//        else if (indexPath.row == 8){
//            self.dismiss(animated: false, completion: nil)
//            let ppvc = self.storyboard?.instantiateViewController(withIdentifier: "CmsVC") as! CmsVC
//            ppvc.strTitel = APP_LBL.privacy_policy
//            ppvc.cmsType = .PrivacyPolicy
//            self.parentVc?.navigationController?.pushViewController(ppvc, animated: true)
//        }
        


