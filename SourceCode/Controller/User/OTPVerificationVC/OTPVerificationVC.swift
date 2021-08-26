//
//  OTPVerificationVC.swift
//  SourceCode
//
//  Created by Yesha on 07/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class OTPVerificationVC: BaseVC, UITextFieldDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblOtpVerification: UILabel!
    @IBOutlet weak var lblSentYouSms: UILabel!
    @IBOutlet weak var otp1view: UIView!
    @IBOutlet weak var txtNum1: UITextField!
    @IBOutlet weak var otp2view: UIView!
    @IBOutlet weak var txtNum2: UITextField!
    @IBOutlet weak var otp3view: UIView!
    @IBOutlet weak var txtNum3: UITextField!
    @IBOutlet weak var otp4view: UIView!
    @IBOutlet weak var txtNum4: UITextField!
    @IBOutlet weak var lblExpiring: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnResendCode: UIButton!
    
    var isValidated = true
    var userData : User?
    var counter: Int = 300
    var timer = Timer()
    var isRuning = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       hideNavigationBar()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let validString : String = "0123456789"
        
        if string.isEmpty == false && validString.contains(string) == false{
            return false;
        }
        
        if textField.text == "" {
            textField.text = ""
        }
        
        
        if textField == txtNum1 {
            
            if !(string == "") {
                
                textField.text = string
                txtNum2.becomeFirstResponder()
                return false
            }
            
        } else if textField == txtNum2 {
            
            if (string == "") {
                
                textField.text = " "
                txtNum1.becomeFirstResponder()
                return false
                
            } else {
                
                textField.text = string
                txtNum3.becomeFirstResponder()
                return false
            }
            
        } else if textField == txtNum3 {
            
            if (string == "") {
                
                textField.text = " "
                txtNum2.becomeFirstResponder()
                return false
                
            } else {
                textField.text = string
                txtNum4.becomeFirstResponder()
                return false
            }
            
        } else if textField == txtNum4 {
            
            if (string == "") {
                
                textField.text = " "
                txtNum3.becomeFirstResponder()
                return false
                
            } else {
                
                textField.text = string
                textField.resignFirstResponder()
                return false
            }
            
        }
        
        return true
        
//        let maxLength = 1
//        let currentString: NSString = (textField.text ?? "") as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
    }
//
//    @objc func textFieldDidChange(_ textField: UITextField) {
//
//        if textField == txtNum1 {
//            if (textField.text?.count)! >= 1 {
//
//                txtNum2?.becomeFirstResponder()
//            }
//        }
//        else if textField == txtNum2 {
//
//            if (textField.text?.count)! >= 1 {
//                txtNum3?.becomeFirstResponder()
//            }
//        }
//        else if textField == txtNum3 {
//
//            if (textField.text?.count)! >= 1 {
//                txtNum4?.becomeFirstResponder()
//            }
//        }
//        else if textField == txtNum4 {
//
//            if (textField.text?.count)! >= 1 {
//                txtNum4.resignFirstResponder()
//            }
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            if textField == txtNum1 {
                
                txtNum2.becomeFirstResponder()
                
            } else if textField == txtNum2 {
                
                txtNum3.becomeFirstResponder()
                
            } else if textField == txtNum3 {
                
                txtNum4.becomeFirstResponder()
                
            } else {
                
                textField.resignFirstResponder()
            }
        
            return true
        }
        
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVerifyAction(_ sender: Any) {
        
        guard let Otp1 = txtNum1.text, let Otp2 = txtNum2.text, let Otp3 = txtNum3.text, let Otp4 = txtNum4.text else {
            return
        }
        if Otp1.isEmpty || Otp1.isReallyEmptyOTPV {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_otp)
        } else if Otp2.isEmpty || Otp2.isReallyEmptyOTPV {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_otp)
        } else if Otp3.isEmpty || Otp3.isReallyEmptyOTPV {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_otp)
        } else if Otp4.isEmpty || Otp4.isReallyEmptyOTPV {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_otp)
        } else  {
           // APP_DEL.currentUser = userData!
           // APP_DEL.currentUser?.syncronize()
           // APP_DEL.setTabbar()
            isValidated = true
            goToNextScreen()
        }
    }
    
    func goToNextScreen(){
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CreatePasswordVC") as! CreatePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnResendCodeAction(_ sender: Any) {
        
        if self.isRuning {
            self.isRuning = false
            self.timer.invalidate()
        }
        self.updateCounter()
    }
    
    @objc func updateCounter() {
        
        if (counter > -1) {
            
            let minutes = (counter % 3600) / 60
            let seconds = counter % 60
            lblExpiring.text = ("\(APP_LBL.expiring_in)" +  "\(minutes)" + ":" + "\(seconds)")
            counter -= 1
        } else {
            
            timer.invalidate()
        }
        
        if (counter == 0) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                self.lblExpiring.isHidden = true
            }
        }
    }
}

extension OTPVerificationVC {
    
    func setUI(){
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        txtNum1.delegate = self
        txtNum2.delegate = self
        txtNum3.delegate = self
        txtNum4.delegate = self
        
        txtNum1?.addTarget(self, action: #selector(OTPVerificationVC.textFieldShouldReturn(_:)), for: UIControl.Event.editingChanged)
        txtNum2?.addTarget(self, action: #selector(OTPVerificationVC.textFieldShouldReturn(_:)), for: UIControl.Event.editingChanged)
        txtNum3?.addTarget(self, action: #selector(OTPVerificationVC.textFieldShouldReturn(_:)), for: UIControl.Event.editingChanged)
        txtNum4?.addTarget(self, action: #selector(OTPVerificationVC.textFieldShouldReturn(_:)), for: UIControl.Event.editingChanged)
        
        lblOtpVerification.text = APP_LBL.otp_verificaton
        lblOtpVerification.font = Utility.SetSemiBold(Utility.BigLabelSize() - 2)
        lblOtpVerification.textColor = APP_COL.APP_Black_Color
        
        lblSentYouSms.text = APP_LBL.we_have_sent_you_an_sms_with_a_code
        lblSentYouSms.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblSentYouSms.textColor = APP_COL.APP_Grey_Color
        
        //lblExpiring.text = APP_LBL.expiring_in
        lblExpiring.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblExpiring.textColor = APP_COL.APP_Grey_Color
        
        txtNum1.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
        txtNum1.textColor = APP_COL.APP_DarkGrey_Color
        otp1view.backgroundColor = APP_COL.txtBGcolor
        otp1view.roundView()
        
        txtNum2.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
        txtNum2.textColor = APP_COL.APP_DarkGrey_Color
        otp2view.backgroundColor = APP_COL.txtBGcolor
        otp2view.roundView()
        
        txtNum3.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
        txtNum3.textColor = APP_COL.APP_DarkGrey_Color
        otp3view.backgroundColor = APP_COL.txtBGcolor
        otp3view.roundView()
        
        txtNum4.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
        txtNum4.textColor = APP_COL.APP_DarkGrey_Color
        otp4view.backgroundColor = APP_COL.txtBGcolor
        otp4view.roundView()
        
        btnVerify.setTitle(APP_LBL.verify, for: .normal)
        btnVerify.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnVerify.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnVerify.backgroundColor = APP_COL.APP_Color
        btnVerify.roundButton()
        
        btnResendCode.setTitle(APP_LBL.re_send_code, for: .normal)
        btnResendCode.titleLabel?.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        btnResendCode.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

    }
    
    
}

extension String {
    var isReallyEmptyOTPV : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
