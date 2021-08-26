//
//  CompanyOTPVerifivationVC.swift
//  SourceCode
//
//  Created by Yesha on 04/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class CompanyOTPVerifivationVC: BaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblOtpVerify: UILabel!
    @IBOutlet weak var lblOtpVerifyDiscription: UILabel!
    
    @IBOutlet weak var otp1view: UIView!
    @IBOutlet weak var txtotp1: UITextField!
    @IBOutlet weak var otp2view: UIView!
    @IBOutlet weak var txtotp2: UITextField!
    @IBOutlet weak var otp3view: UIView!
    @IBOutlet weak var txtotp3: UITextField!
    @IBOutlet weak var otp4view: UIView!
    @IBOutlet weak var txtotp4: UITextField!
    
    @IBOutlet weak var lblexpiring: UILabel!
    
    @IBOutlet weak var btnverify: UIButton!
    
    @IBOutlet weak var btnReSend: UIButton!
    
    var isValidated = true
    let totalSecond = 180
    var second = 0
    var timer = Timer()
    var isRunning = true
    var isFromForgotPassword = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        runTimer()
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
        
        
        if textField == txtotp1 {
            
            if !(string == "") {
                
                textField.text = string
                txtotp2.becomeFirstResponder()
                return false
            }
            
        } else if textField == txtotp2 {
            
            if (string == "") {
                
                textField.text = " "
                txtotp1.becomeFirstResponder()
                return false
                
            } else {
                
                textField.text = string
                txtotp3.becomeFirstResponder()
                return false
            }
            
        } else if textField == txtotp3 {
            
            if (string == "") {
                
                textField.text = " "
                txtotp2.becomeFirstResponder()
                return false
                
            } else {
                textField.text = string
                txtotp4.becomeFirstResponder()
                return false
            }
            
        } else if textField == txtotp4 {
            
            if (string == "") {
                
                textField.text = " "
                txtotp3.becomeFirstResponder()
                return false
                
            } else {
                
                textField.text = string
                textField.resignFirstResponder()
                return false
            }
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtotp1 {
            
            txtotp2.becomeFirstResponder()
            
        } else if textField == txtotp2 {
            
            txtotp3.becomeFirstResponder()
            
        } else if textField == txtotp3 {
            
            txtotp4.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVerifyAction(_ sender: Any) {
        guard let Otp1 = txtotp1.text, let Otp2 = txtotp2.text, let Otp3 = txtotp3.text, let Otp4 = txtotp4.text else {
            return
        }
        if Otp1.isEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_otp)
        } else if Otp2.isEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_otp)
        } else if Otp3.isEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_otp)
        } else if Otp4.isEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_otp)
        } else  {
            isValidated = true
            self.showProgressHUD()
            let par : [String : String] = [
                "user_id" : APP_DEL.currentUser!.user_id!,
                "otp" : txtotp1.text! + txtotp2.text! + txtotp3.text! + txtotp4.text!,
                "token" : APP_DEL.currentUser!.token!,
                "device_type" : "1",
                "user_type" : APP_DEL.currentUser!.user_type!,
            ]
            
            API.verify_otp(param: par) { (user, mess) in
                
                if mess == nil {
                    
                    if self.isFromForgotPassword == "0"
                    {
                        APP_DEL.currentUser = user
                        APP_DEL.currentUser?.syncronize()
                        APP_DEL.setTabbar()
                    } else
                    {
                        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CreatePasswordVC") as! CreatePasswordVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    
                    self.showAlert(message: mess ?? "")
                }
                self.hideProgressHUD()
            }
        }
    }
    
    @IBAction func btnReSendAction(_ sender: Any) {
        if self.isRunning {
            self.isRunning = false
            self.timer.invalidate()
        }
        
        self.showProgressHUD()
        let par : [String : String] = [
            "user_id" : APP_DEL.currentUser!.user_id!,
            "token" : APP_DEL.currentUser!.token!,
            "mobile_number" : APP_DEL.currentUser!.mobile!,
            "user_type" : APP_DEL.currentUser!.user_type!,
        ]
        API.resend_otp(param: par) { (user, mes) in
            if mes == nil {
                APP_DEL.currentUser?.otp = user?.data![0].otp
                self.runTimer()
                self.setUI()
            } else
            {
                self.showAlert(message: mes ?? "")
            }
            self.hideProgressHUD()
        }
    }
    
    func runTimer() {
        
        second = totalSecond
        isRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if second > 0 {
            
            isRunning = true
            second = (second - 1)
            let res = APP_FUNC.getHmsFromCMTime(timeSecond: second)
            lblexpiring.text = APP_LBL.expiring_in + " \(res.m):\(res.s)"
            btnReSend.isHidden = true
            
        } else {
            
            isRunning = false
            timer.invalidate()
            lblexpiring.text =  "Expired" //APP_LBL.expiring_in + " 00:00"
            btnReSend.isHidden = false
        }
    }
    
    //    @objc func updateCounter() {
    //
    //        if (counter > -1) {
    //
    //            let minutes = (counter % 3600) / 60
    //            let seconds = counter % 60
    //            self.isRuning = true
    //            lblexpiring.text = ("\(APP_LBL.expiring_in)" +  "\(minutes)" + ":" + "\(seconds)")
    //            counter -= 1
    //        } else {
    //            isRuning = false
    //            timer.invalidate()
    //            self.lblexpiring.text = APP_LBL.expiring_in + "00:00"
    //        }
    //
    ////        if (counter == 0) {
    ////
    ////            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    ////
    ////                self.lblexpiring.isHidden = true
    ////            }
    ////        }
    //    }
    
}

extension CompanyOTPVerifivationVC {
    
    func setUI(){
        
        //timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        txtotp1.delegate = self
        txtotp2.delegate = self
        txtotp3.delegate = self
        txtotp4.delegate = self
        
        print("%@",APP_DEL.currentUser!)
        
        let test = APP_DEL.currentUser!.otp!
        
        self.txtotp1.text = String(test[test.index(test.startIndex, offsetBy: 0)])
        self.txtotp2.text = String(test[test.index(test.startIndex, offsetBy: 1)])
        self.txtotp3.text = String(test[test.index(test.startIndex, offsetBy: 2)])
        self.txtotp4.text = String(test[test.index(test.startIndex, offsetBy: 3)])
        
        txtotp1?.addTarget(self, action: #selector(OTPVerificationVC.textFieldShouldReturn(_:)), for: UIControl.Event.editingChanged)
        txtotp2?.addTarget(self, action: #selector(OTPVerificationVC.textFieldShouldReturn(_:)), for: UIControl.Event.editingChanged)
        txtotp3?.addTarget(self, action: #selector(OTPVerificationVC.textFieldShouldReturn(_:)), for: UIControl.Event.editingChanged)
        txtotp4?.addTarget(self, action: #selector(OTPVerificationVC.textFieldShouldReturn(_:)), for: UIControl.Event.editingChanged)
        
        lblOtpVerify.text = APP_LBL.otp_verificaton
        lblOtpVerify.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
        lblOtpVerify.textColor = APP_COL.APP_Black_Color
        
        lblOtpVerifyDiscription.text = APP_LBL.we_have_sent_you_an_sms_with_a_code + " " + APP_DEL.currentUser!.country_code! + " " + APP_DEL.currentUser!.mobile!
        lblOtpVerifyDiscription.font = Utility.SetRagular(Utility.Small_size_14() + 1)
        lblOtpVerifyDiscription.textColor = APP_COL.APP_Black_Color
        
        lblexpiring.text = APP_LBL.expiring_in + " 03:00"
        lblexpiring.font = Utility.SetRagular(Utility.Small_size_14() + 1)
        lblexpiring.textColor = APP_COL.APP_Textfield_Color
        
        txtotp1.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        txtotp1.textColor = APP_COL.APP_Textfield_Color
        otp1view.backgroundColor = APP_COL.txtBGcolor
        otp1view.roundView()
        
        txtotp2.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        txtotp2.textColor = APP_COL.APP_Textfield_Color
        otp2view.backgroundColor = APP_COL.txtBGcolor
        otp2view.roundView()
        
        txtotp3.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        txtotp3.textColor = APP_COL.APP_Textfield_Color
        otp3view.backgroundColor = APP_COL.txtBGcolor
        otp3view.roundView()
        
        txtotp4.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        txtotp4.textColor = APP_COL.APP_Textfield_Color
        otp4view.backgroundColor = APP_COL.txtBGcolor
        otp4view.roundView()
        
        btnverify.setTitle(APP_LBL.verify, for: .normal)
        btnverify.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnverify.titleLabel?.font = Utility.SetBlack(Utility.Header_Font_size() + 2)
        btnverify.backgroundColor = APP_COL.APP_Color
        btnverify.roundButton()
        
        btnReSend.setTitle(APP_LBL.re_send_code, for: .normal)
        btnReSend.titleLabel?.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        btnReSend.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        btnReSend.isHidden = true
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
}
