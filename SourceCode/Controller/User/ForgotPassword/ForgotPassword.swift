//
//  ForgotPassword.swift
//  SourceCode
//
//  Created by Yesha on 07/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import CoreTelephony

class ForgotPasswordVC: BaseVC {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblForgot: UILabel!
    //@IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var lblPleaseEnterEmail: UILabel!
    @IBOutlet weak var mobileview: UIView!
    
    @IBOutlet weak var lblcountrycode: UILabel!
    @IBOutlet weak var txtmobile: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    var isValidated = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    @IBAction func btnSend(_ sender: Any) {
        
        guard let mobile = txtmobile.text else {
            return
        }
        
        if mobile.isEmpty || mobile.isReallyEmptyFB {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        } else if !APP_FUNC.isValidContactNumber(number: mobile) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        } else if !APP_FUNC.isValidContactNumber(number: txtmobile.text!) {

            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        }else {
            
            isValidated = true
              //  http://towrevo.vrinsoft.in/api//forgotpassword?mobile_number=99589659850
                self.showProgressHUD()
                let par : [String : String] = [
                    "mobile_number" : self.txtmobile.text!
                ]

                API.forgot_password(param: par) { (user, mess) in

                    if mess == nil {
                        APP_DEL.currentUser = user
                        self.goToOtpScreen()
                    } else {

                        self.showAlert(message: mess ?? "")
                    }
                    
                    self.hideProgressHUD()
                }
            
        }
    }
    
    func goToOtpScreen(){
        removeData()
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyOTPVerifivationVC") as! CompanyOTPVerifivationVC
        vc.isFromForgotPassword = "1"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    func removeData()
    {
        txtmobile.text = ""
    }
}

extension ForgotPasswordVC : UITextFieldDelegate {
    
    func setUI(){
        
        
        
//        lblemail.text = APP_LBL.password
//        lblemail.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
//        lblPassword.textColor = APP_COL.APP_Black_Color
        txtmobile.delegate = self
        
        lblForgot.text = APP_LBL.forgot_password_question
        lblForgot.font = Utility.SetBold(Utility.BigLabelSize() - 2)
        lblForgot.textColor = APP_COL.APP_Black_Color
        
        lblPleaseEnterEmail.text = APP_LBL.forget_password_discription
        lblPleaseEnterEmail.font = Utility.SetRagular(Utility.Small_size_14())
        lblPleaseEnterEmail.textColor = APP_COL.APP_Black_Color
        
        lblmobile.text = APP_LBL.mobile_number_colon
        lblmobile.font = Utility.SetBlack(Utility.Small_size_14())
        lblmobile.textColor = APP_COL.APP_Black_Color
        
       if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
           print(countryCode)
//           let strCode = Countries.countryFromCountryCode(countryCode: countryCode)
//           btnPhoneCode.setTitle("+\(strCode.phoneExtension)", for: .normal)
        lblcountrycode.text = String(format: "+ %@", APP_FUNC.GetCountryCallingCode(countryRegionCode: countryCode)!)
       }
       
        lblcountrycode.font = Utility.SetSemiBold(Utility.Small_size_14())
        lblcountrycode.textColor = APP_COL.APP_Color
        
        txtmobile.font = Utility.SetRagular(Utility.Small_size_14())
        txtmobile.textColor = APP_COL.APP_DarkGrey_Color
        
        mobileview.backgroundColor = APP_COL.txtBGcolor
        mobileview.roundView()
        
        btnSend.setTitle(APP_LBL.send, for: .normal)
        btnSend.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnSend.titleLabel?.font = Utility.SetBlack(Utility.Header_Font_size() + 2)
        btnSend.backgroundColor = APP_COL.APP_Color
        btnSend.roundButton()
        
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//            if (textField == txtmobile) {
//    
//                if let text = textField.text, let range = Range(range, in: text) {
//    
//                    let final = text.replacingCharacters(in: range, with: string)
//    
//                    if (final.count < 0) {
//    
//                        //textField.text = "+91 "
//                        return false
//    
//                    } else {
//    
//                        textField.text = APP_FUNC.formattedNumber(formate: "XXX XXX XXXX", number: final)
//                        return false
//                    }
//    
//                } else {
//    
//                    return false
//                }
//            }
//    
//            return true
//        }
}

extension String {
    var isReallyEmptyFB : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
