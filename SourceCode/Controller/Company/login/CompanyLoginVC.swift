//
//  CompanyLoginVC.swift
//  SourceCode
//
//  Created by Yesha on 03/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class CompanyLoginVC: BaseVC {

    //@IBOutlet weak var btnback: UIButton!
    //@IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbllogin: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var lblpassword: UILabel!
    @IBOutlet weak var passwordview: UIView!
    @IBOutlet weak var txtpassword: UITextField!
    
    @IBOutlet weak var btneye: UIButton!
    
    @IBOutlet weak var btnforgetpassword: UIButton!
    @IBOutlet weak var btnlogin: UIButton!
    
    @IBOutlet weak var lbldonthaveaccount: UILabel!
    @IBOutlet weak var btnregister: UIButton!
    
    var isValidated = true
    var iconClick = true
    
    var useremail : String?
    var companyemail : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
//    @IBAction func btnBackAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @IBAction func btnEyeAction(_ sender: Any) {
        if(iconClick == true) {
            txtpassword.isSecureTextEntry = false
            btneye.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtpassword.isSecureTextEntry = true
            btneye.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    @IBAction func btnForgetPasswordAction(_ sender: Any) {
        removeData()
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
    
        guard let email = txtemail.text , let password = txtpassword.text else{
            return
        }
        
        if email.isEmpty || email.isReallyEmptyCL{
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        
        }  else if (email.isEmpty) || email.isReallyEmptyCR {
    
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        } else if !APP_FUNC.isValidContactNumber(number: email) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        } else if password.isEmpty || password.isReallyEmptyCL{
        
            isValidated = false
            showAlert(message: APP_LBL.please_enter_password)
        
        } else {
        
            isValidated = true
                      self.showProgressHUD()
                      
                      let par : [String : String] = [
                          "email_address" : self.txtemail.text!,
                          "password" : self.txtpassword.text!,
                          "device_token" : APP_DEL.deviceToken,
                          "device_type" : "1"
                      ]

                      API.login(param: par) { (user, mess) in

                          if mess == nil {

                              APP_DEL.currentUser = user
                              APP_DEL.currentUser?.syncronize()
                            APP_DEL.setTabbar()

                          } else if mess == "Inactive User"
                          {
                              APP_DEL.currentUser = user
                              self.goToOtpScreen()
                          }
                            else {

                              self.showAlert(message: mess ?? "")
                          }
                          self.hideProgressHUD()
                      }
        }
    
    }
    func goToOtpScreen(){
           removeData()
           let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyOTPVerifivationVC") as! CompanyOTPVerifivationVC
           self.navigationController?.pushViewController(vc, animated: true)
       }
    @IBAction func btnRegisterAction(_ sender: Any) {
        removeData()
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "MainRegisterVC") as! MainRegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CompanyLoginVC {
    func removeData()
    {
        txtemail.text = ""
        txtpassword.text = ""
    }
    func setUI(){
        
//        lbltitle.text = "Company Registration"
//        lbltitle.font = Utility.SetRagular(Utility.Header_Font_size())
//        lbltitle.textColor = APP_COL.APP_Black_Color
        
        //btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        //let imageurl = "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"
        imgLogo.image = APP_IMG.logo //UIImage.init(named: APP_IMG.logo)
        imgLogo.contentMode = .scaleAspectFit
        
        lbllogin.text = APP_LBL.login
        lbllogin.font = Utility.SetBold(Utility.BigLabelSize())
        lbllogin.textColor = APP_COL.APP_Black_Color
        
        lbldonthaveaccount.text = APP_LBL.dont_have_an_account
        lbldonthaveaccount.font = Utility.SetBlack(Utility.Small_size_14())
        lbldonthaveaccount.textColor = APP_COL.APP_Black_Color
        
        lblemail.text = APP_LBL.mobile_number_colon
        lblemail.font = Utility.SetBlack(Utility.Small_size_14())
        lblemail.textColor = APP_COL.APP_Black_Color
        
        emailview.backgroundColor = APP_COL.txtBGcolor
        emailview.roundView()
        emailview.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3)
        
        txtemail.font = Utility.SetRagular(Utility.Small_size_14())
        txtemail.textColor = APP_COL.APP_DarkGrey_Color
        
        lblpassword.text = APP_LBL.password
        lblpassword.font = Utility.SetBlack(Utility.Small_size_14())
        lblpassword.textColor = APP_COL.APP_Black_Color
        
        passwordview.backgroundColor = APP_COL.txtBGcolor
        passwordview.roundView()
        
        txtpassword.font = Utility.SetRagular(Utility.Small_size_14())
        txtpassword.textColor = APP_COL.APP_DarkGrey_Color
        
        btnforgetpassword.setTitle(APP_LBL.forgot_password_question.uppercased(), for: .normal)
        btnforgetpassword.titleLabel?.font = Utility.SetBlack(Utility.Small_size_14() )
        btnforgetpassword.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        btnlogin.setTitle(APP_LBL.login, for: .normal)
        btnlogin.titleLabel?.font = Utility.SetBlack(Utility.Header_Font_size() + 2)
        btnlogin.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnlogin.backgroundColor = APP_COL.APP_Color
         btnlogin.roundCorner(value: 4.0)
       // btnlogin.roundButton()
        btnlogin.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btnlogin.layer.shadowOffset = CGSize.zero
        btnlogin.layer.shadowOpacity = 0.5
        btnlogin.layer.shadowRadius = 10.0
        btnlogin.layer.masksToBounds = false
        
        btnregister.setTitle(APP_LBL.register.uppercased(), for: .normal)
        btnregister.titleLabel?.font = Utility.SetBlack(Utility.Small_size_14())
        btnregister.setTitleColor(APP_COL.APP_Color, for: .normal)
    }
    
}

extension String {
    var isReallyEmptyCL : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
