//
//  CompanyRegisterVC.swift
//  SourceCode
//
//  Created by Yesha on 02/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import GooglePlaces

class CompanyRegisterVC: BaseVC,interestedDelegate,AddEditAddress {
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    
    @IBOutlet weak var btneditprofile: UIButton!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var imgedit: UIImageView!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var vwCategory: UIView!
    @IBOutlet var txtCategory: UITextField!
    
    
    @IBOutlet weak var txtcompanyname: UITextField!
    @IBOutlet weak var lblcompanyname: UILabel!
    @IBOutlet weak var txtview: UIView!
    
    @IBOutlet weak var lblabout: UILabel!
    @IBOutlet weak var aboutview: UIView!
    // @IBOutlet weak var txtabout: UITextField!
    @IBOutlet weak var txtabout: UITextView!
    
    @IBOutlet weak var hoursview: UIView!
    @IBOutlet weak var lblhours: UILabel!
    @IBOutlet weak var txthours: UITextField!
    
    
    @IBOutlet weak var addrview: UIView!
    @IBOutlet weak var lbladdress: UILabel!
    //@IBOutlet weak var txtaddress: UITextField!
    @IBOutlet weak var txtaddress: UITextView!
    
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var txtemail: UITextField!
    
    
    @IBOutlet weak var lblcountrycode: UILabel!
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var txtmobile: UITextField!
    @IBOutlet weak var mobileview: UIView!
    
    @IBOutlet weak var lblpassword: UILabel!
    @IBOutlet weak var passwordview: UIView!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var btneye: UIButton!
    
    
    @IBOutlet weak var btnregister: UIButton!
    
    @IBOutlet weak var lbltext: UILabel!
    @IBOutlet weak var btnlogin: UIButton!
    var dictImage : [String : UIImage] = [:]
    let AT = AttachmentHandler.shared
    
    var isValidated = true
    var usertype : String?
    
    var categoryMod : categoryModel?
    var categoryList : [category] = []
    var selectedCat = String()
    var arrID = NSMutableArray()
    
    var selectedLatitude = ""
    var selectedLongitude = ""
    var selectedAddress = ""
    
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
  override var preferredStatusBarStyle: UIStatusBarStyle
  {
    return .default
    }
    func setUI(){
        
        txtmobile.delegate = self
        txtcompanyname.delegate = self
        txtabout.delegate = self
        txthours.delegate = self
        txtemail.delegate = self
        txtaddress.delegate = self
        txtpassword.delegate = self
        
        imgedit.layer.cornerRadius = imgedit.frame.size.width / 2
        imgedit.layer.masksToBounds = true
        
        lbltitle.text = APP_LBL.company_register
        lbltitle.font = Utility.SetSemiBold(Utility.Header_Font_size())
        lbltitle.textColor = APP_COL.APP_Black_Color
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        //imgedit.contentMode = .scaleAspectFit
        
        lblcompanyname.text = APP_LBL.company_name_colon
        lblcompanyname.font = Utility.SetBlack(Utility.Small_size_14())
        lblcompanyname.textColor = APP_COL.APP_Black_Color
        
        txtcompanyname.font = Utility.SetBlack(Utility.Small_size_14())
        txtcompanyname.textColor = APP_COL.APP_DarkGrey_Color
        
        txtview.backgroundColor = APP_COL.txtBGcolor
        txtview.roundView()
        
        lblabout.text = APP_LBL.about_colon
        lblabout.font = Utility.SetBlack(Utility.Small_size_14())
        lblabout.textColor = APP_COL.APP_Black_Color
        
        txtabout.font = Utility.SetBlack(Utility.Small_size_14())
        txtabout.textColor = APP_COL.APP_DarkGrey_Color
        txtabout.backgroundColor = .clear
        
        aboutview.backgroundColor = APP_COL.txtBGcolor
        aboutview.roundView()
        
        lblhours.text = APP_LBL.working_hours_colon
        lblhours.font = Utility.SetBlack(Utility.Small_size_14())
        lblhours.textColor = APP_COL.APP_Black_Color
        
        txthours.font = Utility.SetBlack(Utility.Small_size_14())
        txthours.textColor = APP_COL.APP_DarkGrey_Color
        
        hoursview.backgroundColor = APP_COL.txtBGcolor
        hoursview.roundView()
        
        lblCategory.text = APP_LBL.category
        lblCategory.font = Utility.SetBlack(Utility.Small_size_14())
        lblCategory.textColor = APP_COL.APP_Black_Color
        
        vwCategory.backgroundColor = APP_COL.txtBGcolor
        vwCategory.roundView()
        
        txtCategory.font = Utility.SetBlack(Utility.Small_size_14())
        txtCategory.textColor = APP_COL.APP_DarkGrey_Color
        
        lbladdress.text = APP_LBL.address_colon
        lbladdress.font = Utility.SetBlack(Utility.Small_size_14())
        lbladdress.textColor = APP_COL.APP_Black_Color
        
        txtaddress.font = Utility.SetBlack(Utility.Small_size_14())
        txtaddress.textColor = APP_COL.APP_DarkGrey_Color
        
        addrview.backgroundColor = APP_COL.txtBGcolor
        addrview.roundView()
        
        lblemail.text = APP_LBL.email_address
        lblemail.font = Utility.SetBlack(Utility.Small_size_14())
        lblemail.textColor = APP_COL.APP_Black_Color
        
        txtemail.font = Utility.SetBlack(Utility.Small_size_14())
        txtemail.textColor = APP_COL.APP_DarkGrey_Color
        
        emailview.backgroundColor = APP_COL.txtBGcolor
        emailview.roundView()
        
        lblmobile.text = APP_LBL.mobile_number_colon
        lblmobile.font = Utility.SetBlack(Utility.Small_size_14())
        lblmobile.textColor = APP_COL.APP_Black_Color
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            //           let strCode = Countries.countryFromCountryCode(countryCode: countryCode)
            //           btnPhoneCode.setTitle("+\(strCode.phoneExtension)", for: .normal)
            lblcountrycode.text = String(format: "+ %@", APP_FUNC.GetCountryCallingCode(countryRegionCode: countryCode)!)
        }
        lblcountrycode.font = Utility.SetSemiBold(Utility.Small_size_14())
        lblcountrycode.textColor = APP_COL.APP_Color
        
        txtmobile.font = Utility.SetBlack(Utility.Small_size_14())
        txtmobile.textColor = APP_COL.APP_DarkGrey_Color
        
        mobileview.backgroundColor = APP_COL.txtBGcolor
        mobileview.roundView()
        
        lblpassword.text = APP_LBL.password
        lblpassword.font = Utility.SetBlack(Utility.Small_size_14())
        lblpassword.textColor = APP_COL.APP_Black_Color
        
        txtpassword.font = Utility.SetBlack(Utility.Small_size_14())
        txtpassword.textColor = APP_COL.APP_DarkGrey_Color
        
        passwordview.backgroundColor = APP_COL.txtBGcolor
        passwordview.roundView()
        
        btnregister.setTitle(APP_LBL.register, for: .normal)
        btnregister.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnregister.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnregister.backgroundColor = APP_COL.APP_Color
        btnregister.roundButton()
        
        lbltext.text = APP_LBL.already_have_an_account
        lbltext.font = Utility.SetBlack(Utility.Small_size_14())
        lbltext.textColor = APP_COL.APP_Black_Color
        
        btnlogin.setTitle(APP_LBL.login.uppercased(), for: .normal)
        btnlogin.titleLabel?.font = Utility.SetBlack(Utility.Small_size_14())
        btnlogin.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        imgprofile.rounded()
        imgedit.rounded()
    }
    @IBAction func btnCategoryAction(_ sender: Any) {
            let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "InterestedVC") as! InterestedVC
                  vc.delegate = self
           vc.arrId = arrID
                                  self.navigationController?.pushViewController(vc, animated: true)
       }
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        //        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "MainRegisterVC") as! MainRegisterVC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEyeAction(_ sender: Any) {
        if(iconClick == true) {
            txtpassword.isSecureTextEntry = false
            btneye.setImage(UIImage(named: "eyeOpen"), for: .normal)
        } else {
            txtpassword.isSecureTextEntry = true
            btneye.setImage(UIImage(named: "eyeClose"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    
    @IBAction func btnEditProfileAction(_ sender: Any) {
        AT.showAttachmentActionSheet(type: [.camera, .phoneLibrary], vc: self)
        AT.imagePickedBlock = { (img) in
            self.imgedit.image = img
            let originalImage1 = Utility.compressImage(sourceImage: img)
            self.dictImage = [
                "profile_img" : originalImage1,
            ]
        }
        APP_DEL.isImageAdded = false
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        
        guard let companyname = txtcompanyname.text, let about = txtabout.text, let hours = txthours.text, let address = txtaddress.text, let email = txtemail.text, let mobileNum = txtmobile.text , let password = txtpassword.text else {
            return
        }
        
        if (companyname.isEmpty) || companyname.isReallyEmptyCR {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_name)
        } else if (about.isEmpty) || about.isReallyEmptyCR{
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_about)
        }else if selectedCat == "" {
            
            isValidated = false
            showAlert(message: APP_LBL.please_select_category)
        }else if (hours.isEmpty) || hours.isReallyEmptyCR {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_hours)
        }else if (address.isEmpty) || address.isReallyEmptyCR {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_address)
        } else if email.isEmpty || email.isReallyEmptyCR {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_email)
        } else if !APP_FUNC.isValidEmail(email: email) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_Email)
        } else if (mobileNum.isEmpty) || mobileNum.isReallyEmptyCR {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        }else if !APP_FUNC.isValidContactNumber(number: mobileNum) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        }else if (password.isEmpty) || password.isReallyEmptyCR {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_password)
        } else if ((password.count ) < 4) {
            isValidated = false
            showAlert(message: APP_LBL.password_length_must_be_4_letter)
        }
            //        else if APP_FUNC.isValidContactNumber(number: mobileNum){
            //
            //            isValidated = false
            //            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
            //        }
        else {
            
            //towrevo.vrinsoft.in/api/createcompany?company_name=Yesha C&email_address=ios.vrinsoft@gmail.com&mobile_number=7600005364&address=2913 austin avenue,newyork Citysafdd&about=Description&working_hour=10am to 5pm&latitude=23.0350&longitude=72.5293&device_type=1&password=123456&category_id=1,2,3&profile_img=
            
            isValidated = true
            self.showProgressHUD()
            
            let par : [String : String] = [
                
                "company_name" : self.txtcompanyname.text!,
                "mobile_number" : self.txtmobile.text!,
                "address" : APP_DEL.selectedAddress.address,
                "about" : self.txtabout.text!,
                "email_address" : self.txtemail.text!,
                "password" : self.txtpassword.text!,
                "working_hour" : self.txthours.text!,
                "latitude" : APP_DEL.selectedAddress.lat,
                "longitude" : APP_DEL.selectedAddress.long,
                "category_id" : selectedCat,
                "device_type" : "1",
                "country_code" : lblcountrycode.text!
            ]
            
            API.createcompany(param: par, dictImage: dictImage) { (user, mess) in
                if mess == nil {
                    
                    APP_DEL.currentUser = user
                    
                    let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyOTPVerifivationVC") as! CompanyOTPVerifivationVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    
                    self.showAlert(message: mess ?? "")
                }
                self.hideProgressHUD()
            }
        }
        
        
    }
    @IBAction func btnLocationAction(_ sender: Any) {
        let vc : SelectAddressVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
                          vc.address = APP_DEL.selectedAddress
                   vc.delegateAddEditAddress = self
                          self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLoginAction(_ sender: Any) {
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CompanyLoginVC") as! CompanyLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func SelectedIntrestedID(arrID: NSMutableArray, strID: String, arrIntrested: [category]) {
        print(arrID,strID,arrIntrested)
        selectedCat = strID
     self.arrID = arrID
     let arrTemp = NSMutableArray()
     for i in 0..<arrIntrested.count{
         arrTemp.add((arrIntrested[i].category_name!))
         }
     txtCategory.text = arrTemp.componentsJoined(by: ",")
        print(selectedCat)
    }
    
    func addEditAddress(res: Bool, adddress: Address, addressID: String)
    {
        txtaddress.text = APP_DEL.selectedAddress.address
    }
    
}

extension CompanyRegisterVC : UITextFieldDelegate, UITextViewDelegate {
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == txtaddress
        {
//            let placepicker = GMSAutocompleteViewController()
//            placepicker.delegate = self
//
//            let filter = GMSAutocompleteFilter()
//            filter.type = GMSPlacesAutocompleteTypeFilter.address
//
//            placepicker.autocompleteFilter = filter
//            self.present(placepicker, animated: true, completion: nil)
            
           
        }
        
//        {
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//
//            // Specify the place data types to return.
//            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//                UInt(GMSPlaceField.placeID.rawValue))!
//            autocompleteController.placeFields = fields
//
//            // Specify a filter.
//            let filter = GMSAutocompleteFilter()
//            filter.type = .address
//            autocompleteController.autocompleteFilter = filter
//
//            // Display the autocomplete view controller.
//            present(autocompleteController, animated: true, completion: nil)
//        }
        return true
    }
  
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if (textField == txtmobile) {
//
//            if let text = textField.text, let range = Range(range, in: text) {
//
//                let final = text.replacingCharacters(in: range, with: string)
//
//                if (final.count < 0) {
//
//                    //textField.text = "+91 "
//                    return false
//
//                } else {
//                    
//                    textField.text = APP_FUNC.formattedNumber(formate: "XXX XXX XXXX", number: final)
//                    return false
//                }
//
//            } else {
//
//                return false
//            }
//        }
//
//        //        if string == " " {
//        //            return false
//        //        }
//        //
//        //            return true
//        //        }
//
//        //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        //
//        //        if text == " "{
//        //            return false
//        //        }
//
//        return true
//    }
}

extension String {
    var isReallyEmptyCR : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension CompanyRegisterVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        selectedLatitude = String(format: "%0.7f", place.coordinate.latitude)
        selectedLongitude = String(format: "%0.7f", place.coordinate.longitude)
        selectedAddress = place.formattedAddress ?? ""
        txtaddress.text = selectedAddress
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
