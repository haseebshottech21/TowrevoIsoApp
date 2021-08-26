//
//  SignUp.swift
//  SourceCode
//
//  Created by Yesha on 07/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class SignUp: BaseVC {

    
    @IBOutlet weak var imglogo: UIImageView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblSignUp: UILabel!
    
    @IBOutlet weak var fnameview: UIView!
    @IBOutlet weak var lblfirstname: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var lnameview: UIView!
    @IBOutlet weak var lbllastname: UILabel!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var lblcountrycode: UILabel!
    @IBOutlet weak var mobileview: UIView!
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var txtMobileNum: UITextField!
   
    
    @IBOutlet weak var passwordview: UIView!
    @IBOutlet weak var lblpassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblAlredayHaveAccount: UILabel!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var btnPasswordEye: UIButton!
    
    var dictImage : [String : UIImage] = [:]
    
    @IBOutlet var btnProfile: UIButton!
    var isValidated = true
    var iconClick = true
    
    var usertype : String?
    
    let AT = AttachmentHandler.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
   override var preferredStatusBarStyle: UIStatusBarStyle {
   
        return .default
      }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainRegisterVC") as! MainRegisterVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        
        guard let firstName = txtFirstName.text, let lastName = txtLastName.text, let email = txtEmail.text, let mobileNum = txtMobileNum.text, let password = txtPassword.text else {
            return
        }
        
        if (firstName.isEmpty) || firstName.isReallyEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_first_name)
        } else if (lastName.isEmpty) || lastName.isReallyEmpty  {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_last_name)
        } else if (email.isEmpty) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_email)
        } else if !APP_FUNC.isValidEmail(email: email) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_Email)
        } else if (mobileNum.isEmpty) || mobileNum.isReallyEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        } else if !APP_FUNC.isValidContactNumber(number: mobileNum) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        }else if (password.isEmpty) || password.isReallyEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_password)
        } else if ((password.count ) < 4) {
            isValidated = false
            showAlert(message: APP_LBL.password_length_must_be_4_letter)
        }else {
          //  http://towrevo.vrinsoft.in/api/register?first_name=additya&last_name=birla&email_address=additya%40gmail.com&mobile_number=%2B913332221618&password=123456&device_type=1
            isValidated = true
            self.showProgressHUD()
            
            let par : [String : String] = [
                
                "mobile_number" : self.txtMobileNum.text!,
                "first_name" : self.txtFirstName.text!,
                "last_name" : self.txtLastName.text!,
                "email_address" : self.txtEmail.text!,
                "password" : self.txtPassword.text!,
                "device_type" : "1",
                "country_code" : lblcountrycode.text!
            ]
            API.register(param: par, dictImage: dictImage) { (user, mess) in
                if mess == nil {

                    APP_DEL.currentUser = user
                    
                    let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyOTPVerifivationVC") as! CompanyOTPVerifivationVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {

                    self.showAlert(message: mess ?? "")
                }
                self.hideProgressHUD()
            }
        }
        
    }
    
    func goToHomeScreen(){
        
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        
//        APP_DEL.currentUser = User(user_type: usertype, user_id: 30, first_name: txtFirstName.text, last_name: txtLastName.text, email: txtEmail.text, mobile: txtMobileNum.text, password: "123456", company_name: "", about: "", hours: "", address: "", profile_picture: "", token: "dfgdfgdfg", is_account_private: "no", fb_id: "")
//                    APP_DEL.currentUser?.syncronize()
//                APP_DEL.setTabbar()
        
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnProfileAction(_ sender: Any) {
       AT.showAttachmentActionSheet(type: [.camera, .phoneLibrary], vc: self)
              AT.imagePickedBlock = { (img) in
               self.imglogo.image = img
                let originalImage1 = Utility.compressImage(sourceImage: img)
                self.dictImage = [
                    "profile_img" : originalImage1,
                ]
       }
        APP_DEL.isImageAdded = false
    }
    
    @IBAction func btnSignInAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyLoginVC") as! CompanyLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.popViewController(animated: true)
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
}

extension SignUp : UITextFieldDelegate{
    
    func setUI(){
        
        txtMobileNum.delegate = self
        
        lblSignUp.text = APP_LBL.user_registration
        lblSignUp.font = Utility.SetSemiBold(Utility.BigLabelSize() - 2)
        lblSignUp.textColor = APP_COL.APP_Black_Color
        
        imglogo.layer.cornerRadius = imglogo.frame.size.width / 2
        imglogo.layer.masksToBounds = true
       
        
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lblAlredayHaveAccount.text = APP_LBL.already_have_an_account
        lblAlredayHaveAccount.font = Utility.SetBlack(Utility.Small_size_14())
        lblAlredayHaveAccount.textColor = APP_COL.APP_Textfield_Color
        
        lblfirstname.text = APP_LBL.first_name
        lblfirstname.font = Utility.SetBlack(Utility.Small_size_14())
        lblfirstname.textColor = APP_COL.APP_Black_Color
        
        txtFirstName.font = Utility.SetRagular(Utility.Small_size_14())
        txtFirstName.textColor = APP_COL.APP_Textfield_Color
        
        fnameview.backgroundColor = APP_COL.txtBGcolor
        fnameview.roundView()
        
        lbllastname.text = APP_LBL.last_name
        lbllastname.font = Utility.SetBlack(Utility.Small_size_14())
        lbllastname.textColor = APP_COL.APP_Black_Color
        
        txtLastName.font = Utility.SetRagular(Utility.Small_size_14())
        txtLastName.textColor = APP_COL.APP_Textfield_Color
        
        lnameview.backgroundColor = APP_COL.txtBGcolor
        lnameview.roundView()
        
        lblemail.text = APP_LBL.email_address
        lblemail.font = Utility.SetBlack(Utility.Small_size_14())
        lblemail.textColor = APP_COL.APP_Black_Color
        
        txtEmail.font = Utility.SetRagular(Utility.Small_size_14())
        txtEmail.textColor = APP_COL.APP_Textfield_Color
        
        emailview.backgroundColor = APP_COL.txtBGcolor
        emailview.roundView()
        
        lblpassword.text = APP_LBL.password
        lblpassword.font = Utility.SetBlack(Utility.Small_size_14())
        lblpassword.textColor = APP_COL.APP_Black_Color
        
        txtPassword.font = Utility.SetRagular(Utility.Small_size_14())
        txtPassword.textColor = APP_COL.APP_Textfield_Color
        
        passwordview.backgroundColor = APP_COL.txtBGcolor
        passwordview.roundView()
        
          if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                   print(countryCode)
        //           let strCode = Countries.countryFromCountryCode(countryCode: countryCode)
        //           btnPhoneCode.setTitle("+\(strCode.phoneExtension)", for: .normal)
                lblcountrycode.text = String(format: "+ %@", APP_FUNC.GetCountryCallingCode(countryRegionCode: countryCode)!)
               }
        lblcountrycode.font = Utility.SetSemiBold(Utility.Small_size_12() + 2)
        lblcountrycode.textColor = APP_COL.APP_Color
        
        lblmobile.text = APP_LBL.mobile_number_colon
        lblmobile.font = Utility.SetBlack(Utility.Small_size_12() + 2)
        lblmobile.textColor = APP_COL.APP_Black_Color
        
        txtMobileNum.font = Utility.SetRagular(Utility.Small_size_14())
        txtMobileNum.textColor = APP_COL.APP_Textfield_Color
        
        mobileview.backgroundColor = APP_COL.txtBGcolor
        mobileview.roundView()
        
        btnSignUp.setTitle(APP_LBL.register_small, for: .normal)
        btnSignUp.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnSignUp.titleLabel?.font = Utility.SetBlack(Utility.Header_Font_size() + 2)
        btnSignUp.backgroundColor = APP_COL.APP_Color
        btnSignUp.roundButton()
        btnSignUp.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnSignUp.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnSignUp.layer.shadowOpacity = 1.0
        btnSignUp.layer.shadowRadius = 0.0
        btnSignUp.layer.masksToBounds = false
        btnSignUp.layer.cornerRadius = 4.0
        
        btnSignin.setTitle(APP_LBL.login.uppercased(), for: .normal)
        btnSignin.titleLabel?.font = Utility.SetBlack(Utility.Small_size_14())
        btnSignin.setTitleColor(APP_COL.APP_Color, for: .normal)
    }
    
//func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if (textField == txtMobileNum) {
//
//            if let text = textField.text, let range = Range(range, in: text) {
//
//                let final = text.replacingCharacters(in: range, with: string)
//
//                if (final.count < 0) {
//
//                    //textField.text = "+91 "
//                    return false
//
//                } else {
//
//                    textField.text = APP_FUNC.formattedNumber(formate: "XXX XXX XXXX", number: final)
//                    return false
//                }
//
//            } else {
//
//                return false
//            }
//        }
//
//        return true
//    }
}

extension String {
    var isReallyEmpty : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
