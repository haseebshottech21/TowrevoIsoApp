//
//  EditProfileVC1.swift
//  SourceCode
//
//  Created by Yesha on 20/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class EditProfileVC1: BaseVC, UITextFieldDelegate {

    
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnprofilecamera: UIButton!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var fnameview: UIView!
    @IBOutlet weak var lblfname: UILabel!
    @IBOutlet weak var txtFname: UITextField!
   
    @IBOutlet weak var lnameview: UIView!
    @IBOutlet weak var lbllname: UILabel!
    @IBOutlet weak var txtLname: UITextField!
   
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var lblcountrycode: UILabel!
    @IBOutlet weak var mobileview: UIView!
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var txtMobile: UITextField!
    //@IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    //@IBOutlet weak var btnPasswordEye: UIButton!
    var isValidated = true
    var iconClick = true
    let AT = AttachmentHandler.shared
    var dictImage : [String : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
       hideNavigationBar()
    }
    
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnProfileAction(_ sender: Any) {
       AT.showAttachmentActionSheet(type: [.camera, .phoneLibrary], vc: self)
              AT.imagePickedBlock = { (img) in
               self.imgprofile.image = img
                let originalImage1 = Utility.compressImage(sourceImage: img)
                self.dictImage = [
                    "profile_img" : originalImage1,
                ]
       }
        APP_DEL.isImageAdded = false
    }
    @IBAction func btnSaveAction(_ sender: Any) {
        guard let firstName = txtFname.text, let lastName = txtLname.text, let email = txtEmail.text, let mobileNum = txtMobile.text else {
            return
        }
        
        if (firstName.isEmpty) || firstName.isReallyEmptyUEP {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_first_name)
        } else if (lastName.isEmpty) || lastName.isReallyEmptyUEP{
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_last_name)
        } else if email.isEmpty || email.isReallyEmptyUEP {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_email)
        } else if !APP_FUNC.isValidEmail(email: email) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_Email)
        } else if (mobileNum.isEmpty) || mobileNum.isReallyEmptyUEP {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        } else if !APP_FUNC.isValidContactNumber(number: mobileNum) {

            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        }
    else {
        
        isValidated = true
        self.showProgressHUD()
        
        let par : [String : String] = [
            
            "user_id" : APP_DEL.currentUser!.user_id!,
            "first_name" : self.txtFname.text!,
            "last_name" : self.txtLname.text!,
            "email_address" : self.txtEmail.text!,
            "mobile_number" : self.txtMobile.text!,
            "user_type" : APP_DEL.currentUser!.user_type!,
            "token" : APP_DEL.currentUser!.token!,
            "device_type" : "1",
        ]
        
        API.updateUser(param: par, dictImage: dictImage) { (user, mess) in
            if mess == nil {
                
                APP_DEL.currentUser = user
                APP_DEL.currentUser?.syncronize()
                
                self.showPopAlert(message: APP_LBL.profile_successfully_updated)
                
            } else {
                
                self.showAlert(message: mess ?? "")
            }
            self.hideProgressHUD()
        }
    }
    }
    
//    @IBAction func btnPasswordEyeAction(_ sender: Any) {
//        if(iconClick == true) {
//            txtPassword.isSecureTextEntry = false
//            btnPasswordEye.setImage(UIImage(named: "eyeOpen"), for: .normal)
//        } else {
//            txtPassword.isSecureTextEntry = true
//            btnPasswordEye.setImage(UIImage(named: "eyeClose"), for: .normal)
//        }
//
//        iconClick = !iconClick
//    }
    
    
}

extension EditProfileVC1 {
    
    func setUI() {
        
        txtMobile.delegate = self
        txtFname.delegate = self
        txtLname.delegate = self
        txtEmail.delegate = self
        
       if let imgUrl = APP_DEL.currentUser!.profile_image {
                 
                 imgprofile.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.user_placeholder), options: .refreshCached) { (img, err, _, _) in
                     //self.imgLogo.contentMode = .scaleAspectFill
                 }
             }
        imgprofile.rounded()
        
        lbltitle.text = APP_LBL.edit_profile
        lbltitle.font = Utility.SetSemiBold(Utility.Small_size_14())
        lbltitle.textColor = APP_COL.APP_Black_Color
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lblfname.text = APP_LBL.first_name
        lblfname.font = Utility.SetBlack(Utility.Small_size_14())
        lblfname.textColor = APP_COL.APP_Black_Color
        
        txtFname.font = Utility.SetRagular(Utility.Small_size_14())
        txtFname.textColor = APP_COL.APP_DarkGrey_Color
        txtFname.text = APP_DEL.currentUser!.first_name!
        
        fnameview.backgroundColor = APP_COL.txtBGcolor
        fnameview.roundView()
        
        lbllname.text = APP_LBL.last_name
        lbllname.font = Utility.SetBlack(Utility.Small_size_14())
        lbllname.textColor = APP_COL.APP_Black_Color
        
        txtLname.font = Utility.SetRagular(Utility.Small_size_14())
        txtLname.textColor = APP_COL.APP_DarkGrey_Color
        txtLname.text = APP_DEL.currentUser!.last_name!
        
        lnameview.backgroundColor = APP_COL.txtBGcolor
        lnameview.roundView()
        
        lblemail.text = APP_LBL.email_address
        lblemail.font = Utility.SetBlack(Utility.Small_size_14())
        lblemail.textColor = APP_COL.APP_Black_Color
        
        txtEmail.font = Utility.SetRagular(Utility.Small_size_14())
        txtEmail.textColor = APP_COL.APP_DarkGrey_Color
        txtEmail.text = APP_DEL.currentUser!.email!
        
        emailview.backgroundColor = APP_COL.txtBGcolor
        emailview.roundView()
//        txtPassword.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
//        txtPassword.textColor = APP_COL.APP_DarkGrey_Color
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                   print(countryCode)
        //           let strCode = Countries.countryFromCountryCode(countryCode: countryCode)
        //           btnPhoneCode.setTitle("+\(strCode.phoneExtension)", for: .normal)
                lblcountrycode.text = String(format: "+ %@", APP_FUNC.GetCountryCallingCode(countryRegionCode: countryCode)!)
               }
        lblcountrycode.font = Utility.SetSemiBold(Utility.Small_size_12() + 2)
        lblcountrycode.textColor = APP_COL.APP_Color
        
        lblmobile.text = APP_LBL.mobile_number_colon
        lblmobile.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblmobile.textColor = APP_COL.APP_Black_Color
        
        txtMobile.font = Utility.SetRagular(Utility.Small_size_14())
        txtMobile.textColor = APP_COL.APP_DarkGrey_Color
        txtMobile.text = APP_DEL.currentUser!.mobile!
        
        mobileview.backgroundColor = APP_COL.txtBGcolor
        mobileview.roundView()
        
        btnSave.setTitle(APP_LBL.save, for: .normal)
        btnSave.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnSave.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnSave.backgroundColor = APP_COL.APP_Color
        btnSave.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btnSave.layer.shadowOffset = CGSize.zero
        btnSave.layer.shadowOpacity = 0.5
        btnSave.layer.shadowRadius = 10.0
        btnSave.layer.masksToBounds = false
        btnSave.roundCorner(value: 4.0)
        

    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//            if (textField == txtMobile) {
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
//        
//            return true
//        }
}

extension String {
    var isReallyEmptyUEP : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
