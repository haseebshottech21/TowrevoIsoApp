//
//  LoginVC.swift
//  SourceCode
//
//  Created by Yesha on 07/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {

    @IBOutlet weak var imglogo: UIImageView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblSignin: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var lblpassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var passwordview: UIView!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnPasswordEye: UIButton!
    
    var isValidated = true
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSignInAction(_ sender: Any) {
        
        guard let email = txtEmail.text, let password = txtPassword.text else {
            return
        }
        
        if (email.isEmpty) || email.isReallyEmptyCR {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        } else if !APP_FUNC.isValidContactNumber(number: email) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        } else if (password.isEmpty) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_password)
        }  else {
            isValidated = true
            goToHomeScreen()
        }
    }
    
    func goToHomeScreen(){
        
        //let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC

//        APP_DEL.currentUser = User(user_type: APP_DEL.currentUser?.user_type, user_id: <#T##Int?#>, first_name: <#T##String?#>, last_name: <#T##String?#>, email: <#T##String?#>, mobile: <#T##String?#>, password: <#T##String?#>, company_name: <#T##String?#>, about: <#T##String?#>, hours: <#T##String?#>, address: <#T##String?#>, profile_picture: <#T##String?#>, token: <#T##String?#>, is_account_private: <#T##String?#>, fb_id: <#T##String?#>)
//        APP_DEL.currentUser?.syncronize()
//        APP_DEL.setTabbar()
 
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPasswordEyeAction(_ sender: Any) {
        
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
            btnPasswordEye.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            btnPasswordEye.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        
        //let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        // self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignupAction(_ sender: Any) {
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginVC {
    
    func setUI(){
        
        imglogo.image = APP_IMG.logo //UIImage.init(named: APP_IMG.logo)
        imglogo.contentMode = .scaleAspectFit
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lblSignin.text = APP_LBL.login
        lblSignin.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
        lblSignin.textColor = APP_COL.APP_Black_Color
        
        lblDontHaveAccount.text = APP_LBL.dont_have_an_account
        lblDontHaveAccount.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        lblDontHaveAccount.textColor = APP_COL.APP_Black_Color
        
        lblemail.text = APP_LBL.mobile_number_colon
        lblemail.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblemail.textColor = APP_COL.APP_Black_Color
        
        txtEmail.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        txtEmail.textColor = APP_COL.APP_DarkGrey_Color
        
        emailview.backgroundColor = APP_COL.txtBGcolor
        emailview.roundView()
        
        lblpassword.text = APP_LBL.password
        lblpassword.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblpassword.textColor = APP_COL.APP_Black_Color
        
        txtPassword.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        txtPassword.textColor = APP_COL.APP_DarkGrey_Color
        
        passwordview.backgroundColor = APP_COL.txtBGcolor
        passwordview.roundView()
        
        btnForgotPassword.setTitle(APP_LBL.forgot_password, for: .normal)
        btnForgotPassword.titleLabel?.font = Utility.SetSemiBold(Utility.Small_size_14() )
        btnForgotPassword.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        btnSignIn.setTitle(APP_LBL.login, for: .normal)
        btnSignIn.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnSignIn.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnSignIn.backgroundColor = APP_COL.APP_Color
        btnSignIn.roundButton()
        btnSignIn.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btnSignIn.layer.shadowOffset = CGSize.zero
        btnSignIn.layer.shadowOpacity = 0.5
        btnSignIn.layer.shadowRadius = 5.0
        btnSignIn.layer.masksToBounds = false
        btnSignIn.roundCorner(value: 4.0)
              
        //        btncompany.setImage(UIImage(named: "company_grey1"), for: .normal)
        //        btncompany.contentMode = .scaleAspectFit
                btnSignIn.layer.masksToBounds = false
                btnSignIn.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        //        btncompany.layer.shadowPath = shadowPathCompany.cgPath
                btnSignIn.layer.shadowOpacity = 0.5
                btnSignIn.layer.shadowOffset = CGSize.zero
                btnSignIn.layer.shadowRadius = 5.0
        
        
        
        
        
        
        btnSignup.setTitle(APP_LBL.register.uppercased(), for: .normal)
        btnSignup.titleLabel?.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        btnSignup.setTitleColor(APP_COL.APP_Color, for: .normal)
        
    }
}
