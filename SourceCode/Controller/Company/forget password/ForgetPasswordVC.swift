//
//  ForgetPasswordVC.swift
//  SourceCode
//
//  Created by Yesha on 03/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class ForgetPasswordVC: BaseVC {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblforgetpassword: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var lblmobile: UILabel!
    
    @IBOutlet weak var mobileview: UIView!
    
    @IBOutlet weak var txtmobile: UITextField!
    @IBOutlet weak var btnsend: UIButton!
    
    @IBOutlet weak var lblcountrycode: UILabel!
    
    var isValidated = true
    
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
    
    @IBAction func btnSendAction(_ sender: Any) {
        
       guard let mobile = txtmobile.text else {
            return
        }
        
        if mobile.isEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        } else if !APP_FUNC.isValidContactNumber(number: mobile) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        } else {
            
            isValidated = true
            //goToOtpScreen()
            let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyOTPVerifivationVC") as! CompanyOTPVerifivationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ForgetPasswordVC : UITextFieldDelegate {
    
    func setUI(){
        
        txtmobile.delegate = self
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lblforgetpassword.text = APP_LBL.forgot_password
        lblforgetpassword.font = Utility.SetSemiBold(Utility.BigLabelSize() + -2)
        lblforgetpassword.textColor = APP_COL.APP_Black_Color
        
        lbldescription.text = APP_LBL.forget_password_discription
        lbldescription.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lbldescription.textColor = APP_COL.APP_Grey_Color
        
        lblmobile.text = "Mobile Number:"
        lblmobile.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblmobile.textColor = APP_COL.APP_Black_Color
        
         if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                   print(countryCode)
        //           let strCode = Countries.countryFromCountryCode(countryCode: countryCode)
        //           btnPhoneCode.setTitle("+\(strCode.phoneExtension)", for: .normal)
                lblcountrycode.text = String(format: "+ %@", APP_FUNC.GetCountryCallingCode(countryRegionCode: countryCode)!)
               }
        lblcountrycode.font = Utility.SetSemiBold(Utility.Small_size_12() + 2)
        lblcountrycode.textColor = APP_COL.APP_Color
        
        txtmobile.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtmobile.textColor = APP_COL.APP_DarkGrey_Color
        
        mobileview.backgroundColor = APP_COL.txtBGcolor
        mobileview.roundView()
        
        btnsend.setTitle(APP_LBL.send, for: .normal)
        btnsend.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnsend.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnsend.backgroundColor = APP_COL.APP_Color
        btnsend.roundButton()
        btnsend.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnsend.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnsend.layer.shadowOpacity = 1.0
        btnsend.layer.shadowRadius = 0.0
        btnsend.layer.masksToBounds = false
        btnsend.layer.cornerRadius = 4.0
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
