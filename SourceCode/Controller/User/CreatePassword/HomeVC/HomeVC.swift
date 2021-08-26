//
//  HomeVC.swift
//  SourceCode
//
//  Created by Yesha on 11/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class HomeVC: BaseVC, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var viewPickUpLocation: UIView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    
    
    //var pickerView = UIPickerView()
    var pickerView : UIPickerView!
    var selectedCategory: String?
    var categoryList = ["1", "2", "3", "4", "5", "6"]
    var isValidated = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCategory = "1"
        setUI()
        
        txtCategory.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func pickup(txetfield : UITextField) {
        
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        txtCategory.inputView = pickerView
        
        let toolBar = UIToolbar()
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(actionCancelBtn))
        let title = UIBarButtonItem(title: "Select Category", style: .plain, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(actionDoneBtn))
        toolBar.setItems([cancel,spaceButton,title,spaceButton,done], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtCategory.inputAccessoryView = toolBar
        toolBar.sizeToFit()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickup(txetfield: txtCategory)
    }
    
    // Picker function
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCategory = categoryList[row]
        //txtCategory.text = selectedCategory
    }
    
    
    @IBAction func btnMenuAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        vc.modalPresentationStyle = .overFullScreen
        vc.parentVc = self
        self.present(vc, animated: false, completion: nil)

       
    }
    
    @IBAction func btnLocationAction(_ sender: Any) {
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        
        
        guard let location = txtLocation.text, let category = txtCategory.text  else {
            return
        }
        
        if location.isEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_location)
        } else if (category.isEmpty) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_category)
            
        }  else {
            
            isValidated = true
            moveToNetScreen()
        }
        
    }
    
    func moveToNetScreen(){
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "TowingCompaniesVC") as! TowingCompaniesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func actionDoneBtn() {
        if (categoryList.count > 0){
        txtCategory.text = selectedCategory
        }
        view.endEditing(true)
    }
    @objc func actionCancelBtn(){
        txtCategory.resignFirstResponder()
    }
}


extension HomeVC {
    
    func setUI(){
        
        btnMenu.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        viewContent.roundCorner(value: 15.0)
        viewContent.layer.masksToBounds = false
        viewContent.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        viewContent.layer.shadowOpacity = 0.1
        viewContent.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewContent.layer.shadowRadius = 1.0
        
        viewContent.layer.shouldRasterize = true
        viewContent.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        viewPickUpLocation.roundButton()
        viewPickUpLocation.layer.borderWidth = 0.2
        viewPickUpLocation.layer.borderColor = (APP_COL.APP_Black_Color).cgColor
        
        viewCategory.roundButton()
        viewCategory.layer.borderWidth = 0.2
        viewCategory.layer.borderColor = (APP_COL.APP_Black_Color).cgColor
        
        
        lblPickUpLocation.text = APP_LBL.pickup_location
        lblPickUpLocation.font = Utility.SetSemiBold(Utility.Header_Font_size() + 2)
        lblPickUpLocation.textColor = APP_COL.APP_Black_Color
        
        lblCategory.text = APP_LBL.category
        lblCategory.font = Utility.SetSemiBold(Utility.Header_Font_size() + 2)
        lblCategory.textColor = APP_COL.APP_Black_Color
        
        txtCategory.font = Utility.SetRagular(Utility.Small_size_14() )
        txtCategory.textColor = APP_COL.APP_Black_Color
        
        txtLocation.font = Utility.SetRagular(Utility.Small_size_14() )
        txtLocation.textColor = APP_COL.APP_Black_Color
        txtLocation.layer.borderWidth = 0.0
        
        btnNext.setTitle(APP_LBL.next, for: .normal)
        btnNext.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnNext.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnNext.backgroundColor = APP_COL.APP_Color
        btnNext.roundButton()
        btnNext.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnNext.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnNext.layer.shadowOpacity = 1.0
        btnNext.layer.shadowRadius = 0.0
        btnNext.layer.masksToBounds = false
        btnNext.layer.cornerRadius = 4.0
        
    }
}



