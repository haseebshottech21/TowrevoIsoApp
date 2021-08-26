//
//  CompanyCreatePasswordVC.swift
//  SourceCode
//
//  Created by Yesha on 04/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class CompanyCreatePasswordVC: BaseVC {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblcreatepassword: UILabel!
    
    @IBOutlet weak var lblnewpassword: UILabel!
    @IBOutlet weak var newpasswordview: UIView!
    @IBOutlet weak var txtnewpassword: UITextField!
    @IBOutlet weak var btnneweye: UIButton!
    
    @IBOutlet weak var lblconfirmpassword: UILabel!
    @IBOutlet weak var confirmpassview: UIView!
    @IBOutlet weak var txtconfirmpassword: UITextField!
    @IBOutlet weak var btnconfirmeye: UIButton!
    
    @IBOutlet weak var btnreset: UIButton!
    
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
    @IBAction func btnNewEyeAction(_ sender: Any) {
        if(iconClick == true) {
            txtnewpassword.isSecureTextEntry = false
            btnneweye.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtnewpassword.isSecureTextEntry = true
            btnneweye.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func btnConfirmEyeAction(_ sender: Any) {
        if(iconClick == true) {
            txtconfirmpassword.isSecureTextEntry = false
            btnconfirmeye.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtconfirmpassword.isSecureTextEntry = true
            btnconfirmeye.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
   
    @IBAction func btnReSetAction(_ sender: Any) {
    }
    
}

extension CompanyCreatePasswordVC{
    
    func setUI(){
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lblcreatepassword.text = APP_LBL.create_new_password
        lblcreatepassword.font = Utility.SetSemiBold(Utility.BigLabelSize() + 2)
        lblcreatepassword.textColor = APP_COL.APP_Black_Color
        
        lblnewpassword.text = "New Password:"
        lblnewpassword.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblnewpassword.textColor = APP_COL.APP_Black_Color
        
        txtnewpassword.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtnewpassword.textColor = APP_COL.APP_DarkGrey_Color
        
        newpasswordview.backgroundColor = APP_COL.txtBGcolor
        newpasswordview.roundView()
        
        lblconfirmpassword.text = "Confirm Password:"
        lblconfirmpassword.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblconfirmpassword.textColor = APP_COL.APP_Black_Color
        
        txtconfirmpassword.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtconfirmpassword.textColor = APP_COL.APP_DarkGrey_Color
        
        confirmpassview.backgroundColor = APP_COL.txtBGcolor
        confirmpassview.roundView()
        
        btnreset.setTitle(APP_LBL.reset, for: .normal)
        btnreset.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnreset.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnreset.backgroundColor = APP_COL.APP_Color
        btnreset.roundButton()
        btnreset.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnreset.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnreset.layer.shadowOpacity = 1.0
        btnreset.layer.shadowRadius = 0.0
        btnreset.layer.masksToBounds = false
        btnreset.layer.cornerRadius = 4.0
    }
    
}
