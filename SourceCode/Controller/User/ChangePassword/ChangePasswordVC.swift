//
//  ChangePasswordVC.swift
//  SourceCode
//
//  Created by Yesha on 22/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseVC {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var btnoldeye: UIButton!
    @IBOutlet weak var btnneweye: UIButton!
    @IBOutlet weak var btnconfirmeye: UIButton!
   
    @IBOutlet weak var lbloldpassword: UILabel!
    @IBOutlet weak var oldpassview: UIView!
    @IBOutlet weak var txtOldPassword: UITextField!
    
    @IBOutlet weak var newpassview: UIView!
    @IBOutlet weak var lblnewpassword: UILabel!
    @IBOutlet weak var txtNewPassword: UITextField!
   
    @IBOutlet weak var confirmview: UIView!
    @IBOutlet weak var lblconfirm: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnUpdate: UIButton!
    
    var isValidated = true
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        txtOldPassword.isSecureTextEntry = true
        txtNewPassword.isSecureTextEntry = true
        txtConfirmPassword.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOldEyeAction(_ sender: Any) {
        if(iconClick == true) {
            txtOldPassword.isSecureTextEntry = false
            btnoldeye.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtOldPassword.isSecureTextEntry = true
            btnoldeye.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func btnNewEyeAction(_ sender: Any) {
        if(iconClick == true) {
            txtNewPassword.isSecureTextEntry = false
            btnneweye.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtNewPassword.isSecureTextEntry = true
            btnneweye.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func btnConfirmEyeAction(_ sender: Any) {
        if(iconClick == true) {
            txtConfirmPassword.isSecureTextEntry = false
            btnconfirmeye.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtConfirmPassword.isSecureTextEntry = true
            btnconfirmeye.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        
        guard let oldPassword = txtOldPassword.text, let newPassword = txtNewPassword.text, let confirmPassword = txtConfirmPassword.text else {
            return
        }
        
        if (oldPassword.isEmpty) || oldPassword.isReallyEmptyChP{
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_old_password)
        
        }else if (newPassword.isEmpty) || newPassword.isReallyEmptyChP{
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_new_password)
            
        } else if newPassword == oldPassword {
            
            isValidated = false
            showAlert(message: APP_LBL.new_password_and_old_password_must_be_different )
            
        }else if (confirmPassword.isEmpty) || confirmPassword.isReallyEmptyChP {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_confirm_password)
            
        } else if newPassword != confirmPassword {
            
            isValidated = false
            showAlert(message: APP_LBL.new_password_and_confirm_password_must_be_same )
            
        } else if ((newPassword.count ) < 4) {
            isValidated = false
            showAlert(message: APP_LBL.password_length_must_be_4_letter)
        }else {
            isValidated = true
                self.showProgressHUD()
              //towrevo.vrinsoft.in/api/changepassword?user_id=40&new_password=Admin123@1&confirm_password=Admin123@1&device_type=1&token=9df1767758011609df86df233fb7ff98&user_type=2
                let par : [String : String] = [
                    "user_id" : APP_DEL.currentUser!.user_id!,
                    "new_password" : self.txtNewPassword.text!,
                    "confirm_password" : self.txtConfirmPassword.text!,
                    "device_type" : "1",
                    "token": APP_DEL.currentUser!.token!,
                    "user_type": APP_DEL.currentUser!.user_type!,
                    "current_password": self.txtOldPassword.text!
                    
                    
                ]

                API.updatepassword(param: par) { (codMod, mess) in
                    self.hideProgressHUD()
                    
                    if mess == nil {

                        self.showPopAlert(message: APP_LBL.password_successfully_changed)
                        
                    } else {

                        self.showAlert(message: mess ?? "")
                    }
                }
            
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
           {
           return .default
       }
}

extension ChangePasswordVC : UITextFieldDelegate {
    func setUI(){
        
        txtOldPassword.delegate = self
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self

        lbltitle.text = APP_LBL.change_password
        lbltitle.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lbltitle.textColor = APP_COL.APP_Black_Color
        
        lbloldpassword.text = APP_LBL.old_password_colon
        lbloldpassword.font = Utility.SetBlack(Utility.Small_size_14())
        lbloldpassword.textColor = APP_COL.APP_Black_Color
        
        txtOldPassword.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        txtOldPassword.textColor = APP_COL.APP_DarkGrey_Color
        
        oldpassview.backgroundColor = APP_COL.txtBGcolor
        oldpassview.roundView()
        
        lblnewpassword.text = APP_LBL.new_password_colon
        lblnewpassword.font = Utility.SetBlack(Utility.Small_size_14())
        lblnewpassword.textColor = APP_COL.APP_Black_Color
        
        txtNewPassword.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        txtNewPassword.textColor = APP_COL.APP_DarkGrey_Color
        
        newpassview.backgroundColor = APP_COL.txtBGcolor
        newpassview.roundView()
        
        lblconfirm.text = APP_LBL.confirm_password_colon
        lblconfirm.font = Utility.SetBlack(Utility.Small_size_14())
        lblconfirm.textColor = APP_COL.APP_Black_Color
        
        txtConfirmPassword.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        txtConfirmPassword.textColor = APP_COL.APP_DarkGrey_Color
        
        confirmview.backgroundColor = APP_COL.txtBGcolor
        confirmview.roundView()
        
        btnUpdate.setTitle(APP_LBL.update, for: .normal)
        btnUpdate.titleLabel?.font = Utility.SetBlack(Utility.Small_size_14() + 4)
        btnUpdate.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnUpdate.backgroundColor = APP_COL.APP_Color
        btnUpdate.roundButton()
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if string == " "{
//            return false
//        }
//
//        return true
//    }
    
}

extension String {
    var isReallyEmptyChP: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
