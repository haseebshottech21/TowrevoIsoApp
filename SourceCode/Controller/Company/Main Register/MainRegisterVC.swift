//
//  MainRegisterVC.swift
//  SourceCode
//
//  Created by Yesha on 02/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class MainRegisterVC: UIViewController {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var lblregisteras: UILabel!
    
    @IBOutlet weak var lbldescription: UILabel!
    
    @IBOutlet weak var btncompany: UIButton!
    
    @IBOutlet weak var btnuser: UIButton!
    
    @IBOutlet weak var lblcompany: UILabel!
    @IBOutlet weak var lbluser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 setUI()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnCompanyAction(_ sender: Any) {

        APP_DEL.SelectedUserType = .Company
        
        btncompany.backgroundColor = (APP_COL.APP_Color)
        lblcompany.textColor = APP_COL.APP_Color
        btncompany.setImage(UIImage(named: "building_white"), for: .normal)
        btncompany.contentMode = .scaleAspectFit

        btnuser.backgroundColor = (APP_COL.APP_White_Color)
        lbluser.textColor = APP_COL.APP_Textfield_Color
        btnuser.setImage(UIImage(named: "user_gray"), for: .normal)
        btnuser.contentMode = .scaleAspectFit
        
       let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyRegisterVC") as! CompanyRegisterVC
        vc.usertype = APP_DEL.SelectedUserType?.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnUseraction(_ sender: Any) {
        
        APP_DEL.SelectedUserType = .User

        btnuser.backgroundColor = (APP_COL.APP_Color)
        lbluser.textColor = APP_COL.APP_Color
        btnuser.setImage(UIImage(named: "user"), for: .normal)
        btnuser.contentMode = .scaleAspectFit

        btncompany.backgroundColor = (APP_COL.APP_White_Color)
        lblcompany.textColor = APP_COL.APP_Textfield_Color
        btncompany.setImage(UIImage(named: "building"), for: .normal)
        btncompany.contentMode = .scaleAspectFit
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        vc.usertype = APP_DEL.SelectedUserType?.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainRegisterVC {
    
    func setUI(){
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lbltitle.text = APP_LBL.register_small
        lbltitle.font = Utility.SetSemiBold(Utility.Header_Font_size())
        lbltitle.textColor = APP_COL.APP_Black_Color
        
        lblregisteras.text = APP_LBL.register_as
        lblregisteras.font = Utility.SetBold(Utility.BigLabelSize())
        lblregisteras.textColor = APP_COL.APP_Black_Color
        
        lbldescription.text = APP_LBL.kindly_select_one_option
        lbldescription.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        lbldescription.textColor = APP_COL.APP_Black_Color
        
        btncompany.roundCorner(value: 10.0)
        btncompany.backgroundColor = (APP_COL.APP_White_Color)
        lblcompany.textColor = APP_COL.APP_Textfield_Color
        btncompany.layer.masksToBounds = false
        btncompany.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btncompany.layer.shadowOpacity = 0.5
        btncompany.layer.shadowOffset = CGSize.zero
        btncompany.layer.shadowRadius = 5.0
        
        lblcompany.text = APP_LBL.company
        lblcompany.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lblcompany.textColor = APP_COL.APP_Grey_Color
        
        btnuser.roundCorner(value: 10.0)
        btnuser.backgroundColor = (APP_COL.APP_White_Color)
        lbluser.textColor = APP_COL.APP_Grey_Color
        btnuser.layer.masksToBounds = false
        btnuser.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btnuser.layer.shadowOpacity = 0.5
        btnuser.layer.shadowOffset = CGSize.zero
        btnuser.layer.shadowRadius = 10.0
        
        lbluser.text = APP_LBL.user
        lbluser.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lbluser.textColor = APP_COL.APP_Textfield_Color
        
    }
}
