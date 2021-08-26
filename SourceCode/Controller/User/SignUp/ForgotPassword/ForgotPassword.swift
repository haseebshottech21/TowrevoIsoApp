//
//  ForgotPassword.swift
//  SourceCode
//
//  Created by Yesha on 07/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class ForgotPassword: BaseVC {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblForgot: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblPleaseEnterEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender: Any) {
    }
    
}

extension ForgotPassword {
    
    func setUI(){
        
        lblForgot.text = APP_LBL.forgot
        lblForgot.font = Utility.SetSemiBold(Utility.BigLabelSize())
        lblForgot.textColor = APP_COL.APP_Black_Color
        
        lblPassword.text = APP_LBL.password
        lblPassword.font = Utility.SetSemiBold(Utility.BigLabelSize())
        lblPassword.textColor = APP_COL.APP_Black_Color
        
        lblPleaseEnterEmail.text = APP_LBL.please_enter_your_email_address_to_reset_your_password
        lblPleaseEnterEmail.font = Utility.SetRagular(Utility.Small_size_12())
        lblPleaseEnterEmail.textColor = APP_COL.APP_Grey_Color
        
        txtEmail.font = Utility.SetRagular(Utility.Header_Font_size())
        txtEmail.textColor = APP_COL.APP_DarkGrey_Color
        
        btnSend.setTitle(APP_LBL.send, for: .normal)
        btnSend.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnSend.titleLabel?.font = Utility.SetRagular(Utility.Small_size_14())
        btnSend.backgroundColor = APP_COL.APP_Color
        btnSend.roundButton()
        
        //        btnBack.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

    }
}
