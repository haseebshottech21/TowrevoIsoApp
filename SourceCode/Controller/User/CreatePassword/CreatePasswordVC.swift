//
//  ChangePasswordVC.swift
//  SourceCode
//
//  Created by Yesha on 07/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class CreatePasswordVC: BaseVC {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblCreateNew: UILabel!
    //@IBOutlet weak var lblPassword: UILabel!
    
    @IBOutlet weak var newpassview: UIView!
    @IBOutlet weak var lblnewpassword: UILabel!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var btnEyeNewPassword: UIButton!
   
    @IBOutlet weak var confirmpasswordview: UIView!
    @IBOutlet weak var lblconfirmpassword: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnEyeConfirmPassword: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    
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
    
    @IBAction func btnEyeConfirmPasswordAction(_ sender: Any) {
        
        if(iconClick == true) {
            txtConfirmPassword.isSecureTextEntry = false
            btnEyeConfirmPassword.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtConfirmPassword.isSecureTextEntry = true
            btnEyeConfirmPassword.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func btnPasswyeNewPAsswordAction(_ sender: Any) {
        
        if(iconClick == true) {
            txtNewPassword.isSecureTextEntry = false
            btnEyeNewPassword.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtNewPassword.isSecureTextEntry = true
            btnEyeNewPassword.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        
       if !self.txtNewPassword.hasText {
            self.showAlert(message: APP_LBL.Please_enter_Password)
        } else if !self.txtConfirmPassword.hasText {
            self.showAlert(message: APP_LBL.Please_enter_Confirm_Password)
        } else if self.txtConfirmPassword.text! != self.txtNewPassword.text! {
            self.showAlert(message: APP_LBL.new_password_and_confirm_password_must_be_same)
        } else if ((self.txtNewPassword.text!.count ) < 4) {
            isValidated = false
            showAlert(message: APP_LBL.password_length_must_be_4_letter)
        }else {
            
            self.showProgressHUD()
          //towrevo.vrinsoft.in/api/changepassword?user_id=40&new_password=Admin123@1&confirm_password=Admin123@1&device_type=1&token=9df1767758011609df86df233fb7ff98&user_type=2
            let par : [String : String] = [
                "user_id" : APP_DEL.currentUser!.user_id!,
                "new_password" : self.txtNewPassword.text!,
                "confirm_password" : self.txtConfirmPassword.text!,
                "device_type" : "1",
                "token": APP_DEL.currentUser!.token!,
                "user_type": APP_DEL.currentUser!.user_type!
                
                
            ]

            API.change_password(param: par) { (codMod, mess) in
                self.hideProgressHUD()
                
                if mess == nil {
                    APP_DEL.currentUser?.logout()
                    APP_DEL.setTabbar()
                    self.showAlert(message: APP_LBL.password_successfully_changed)
                    
                } else {

                    self.showAlert(message: mess ?? "")
                }
            }
        }
    }
}

extension CreatePasswordVC : UITextFieldDelegate {
    
    func setUI(){
        
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self
        
        lblCreateNew.text = APP_LBL.create_new_password
        lblCreateNew.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
        lblCreateNew.textColor = APP_COL.APP_Black_Color
        
        
//        lblPassword.text = APP_LBL.password
//        lblPassword.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
//        lblPassword.textColor = APP_COL.APP_Black_Color
        
        lblnewpassword.text = APP_LBL.new_password_colon
        lblnewpassword.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblnewpassword.textColor = APP_COL.APP_Black_Color
        
        txtNewPassword.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        txtNewPassword.textColor = APP_COL.APP_DarkGrey_Color
        newpassview.backgroundColor = APP_COL.txtBGcolor
        newpassview.roundView()
        
        lblconfirmpassword.text = APP_LBL.confirm_password_colon
        lblconfirmpassword.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblconfirmpassword.textColor = APP_COL.APP_Black_Color
        
        txtConfirmPassword.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        txtConfirmPassword.textColor = APP_COL.APP_DarkGrey_Color
        
        confirmpasswordview.backgroundColor = APP_COL.txtBGcolor
        confirmpasswordview.roundView()
        
        btnReset.setTitle(APP_LBL.reset, for: .normal)
        btnReset.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnReset.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnReset.backgroundColor = APP_COL.APP_Color
        btnReset.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btnReset.layer.shadowOffset = CGSize.zero
        btnReset.layer.shadowOpacity = 0.5
        btnReset.layer.shadowRadius = 10.0
        btnReset.layer.masksToBounds = false
        btnReset.roundCorner(value: 4.0)
        
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

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
    var isReallyEmptyCrePass : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
