//
//  CompanyEditProfileVC.swift
//  SourceCode
//
//  Created by Yesha on 05/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class CompanyEditProfileVC: BaseVC, interestedDelegate, AddEditAddress {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lbltital: UILabel!
    
    @IBOutlet weak var imgprofile: UIImageView!
    //@IBOutlet weak var btncamera: UIImageView!
    @IBOutlet weak var btncamera: UIButton!
    
    @IBOutlet weak var lblcompanyname: UILabel!
    @IBOutlet weak var companyview: UIView!
    @IBOutlet weak var txtcomplayname: UITextField!
    
    @IBOutlet weak var lblabout: UILabel!
    @IBOutlet weak var aboutview: UIView!
    @IBOutlet weak var txtabout: UITextView!
    
    @IBOutlet weak var lblhours: UILabel!
    @IBOutlet weak var hoursview: UIView!
    @IBOutlet weak var txtworkinghours: UITextField!
    
    @IBOutlet weak var lbladdress: UILabel!
    @IBOutlet weak var addressview: UIView!
    @IBOutlet weak var txtaddress: UITextView!
    
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var txtemail: UITextField!
    
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var mobileview: UIView!
    @IBOutlet weak var lblcountrycode: UILabel!
    @IBOutlet weak var txtmobile: UITextField!
    
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var vwCategory: UIView!
    @IBOutlet var txtCategory: UITextField!
    
    @IBOutlet weak var btnsave: UIButton!
    
    var isValidated = true
    var selectedCat = String()
    var arrID = NSMutableArray()
    
    var dictImage : [String : UIImage] = [:]
    let AT = AttachmentHandler.shared
    var selectedArr = NSMutableArray()
    
    var selectedLatitude = ""
    var selectedLongitude = ""
    var selectedAddress = ""
    
    
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
    @IBAction func btnLocationAction(_ sender: Any) {
//        let placepicker = GMSAutocompleteViewController()
//        placepicker.delegate = self
//
//        let filter = GMSAutocompleteFilter()
//        filter.type = GMSPlacesAutocompleteTypeFilter.address
//
//        placepicker.autocompleteFilter = filter
//        self.present(placepicker, animated: true, completion: nil)
        let vc : SelectAddressVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
               vc.address = APP_DEL.selectedAddress
        vc.delegateAddEditAddress = self
               self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSaveAction(_ sender: Any) {
        guard let companyname = txtcomplayname.text, let about = txtabout.text, let hours = txtworkinghours.text, let address = txtaddress.text, let email = txtemail.text, let mobileNum = txtmobile.text else {
                    return
                }
                
        if (companyname.isEmpty) || companyname.isReallyEmptyCEP {
                    
                    isValidated = false
                    showAlert(message: APP_LBL.please_enter_name)
                } else if (about.isEmpty) || about.isReallyEmptyCEP {
                    
                    isValidated = false
                    showAlert(message: APP_LBL.please_enter_about)
                }else if (hours.isEmpty) || hours.isReallyEmptyCEP{
                    
                    isValidated = false
                    showAlert(message: APP_LBL.please_enter_hours)
                }else if (address.isEmpty) || address.isReallyEmptyCEP{
                    
                    isValidated = false
                    showAlert(message: APP_LBL.please_enter_address)
                } else if email.isEmpty || email.isReallyEmptyCEP {
                    
                    isValidated = false
                    showAlert(message: APP_LBL.please_enter_email)
                } else if !APP_FUNC.isValidEmail(email: email) {
                    
                    isValidated = false
                    showAlert(message: APP_LBL.please_enter_valid_Email)
                } else if (mobileNum.isEmpty) || mobileNum.isReallyEmptyCEP{
                    
                    isValidated = false
                    showAlert(message: APP_LBL.please_enter_mobile_number)
                }
       else if !APP_FUNC.isValidContactNumber(number: mobileNum) {

            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        }
                else {
                    
                    //towrevo.vrinsoft.in/api/createcompany?company_name=Yesha C&email_address=ios.vrinsoft@gmail.com&mobile_number=7600005364&address=2913 austin avenue,newyork Citysafdd&about=Description&working_hour=10am to 5pm&latitude=23.0350&longitude=72.5293&device_type=1&password=123456&category_id=1,2,3&profile_img=
                    
                    isValidated = true
                    self.showProgressHUD()
                    
                    let par : [String : String] = [
                        
                        "password" : "",
                        "user_id" : APP_DEL.currentUser!.user_id!,
                        "user_type" :  APP_DEL.currentUser!.user_type!,
                        "token" : APP_DEL.currentUser!.token!,
                        "company_name" : self.txtcomplayname.text!,
                        "mobile_number" : self.txtmobile.text!,
                        "address" : self.txtaddress.text!,
                        "about" : self.txtabout.text!,
                        "email_address" : self.txtemail.text!,
                        "working_hour" : self.txtworkinghours.text!,
                        "latitude" : selectedLatitude,
                        "longitude" : selectedLongitude,
                        "category_id" : selectedCat,
                        "device_type" : "1",
                    ]
            
                    API.updateCompany(param: par, dictImage: dictImage) { (user, mess) in
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
    @IBAction func btnEditProfileAction(_ sender: Any) {
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
    @IBAction func btnCategoryAction(_ sender: Any) {
            let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "InterestedVC") as! InterestedVC
                  vc.delegate = self
           vc.arrId = arrID
                                  self.navigationController?.pushViewController(vc, animated: true)
       }
    @IBAction func btnlocationAction(_ sender: Any) {
    //            let placepicker = GMSAutocompleteViewController()
    //            placepicker.delegate = self
    //
    //            let filter = GMSAutocompleteFilter()
    //            filter.type = GMSPlacesAutocompleteTypeFilter.address
    //
    //            placepicker.autocompleteFilter = filter
    //            self.present(placepicker, animated: true, completion: nil)
                
                let vc : SelectAddressVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
                       vc.address = APP_DEL.selectedAddress
        vc.delegateAddEditAddress = self
                       self.navigationController?.pushViewController(vc, animated: true)
                
            }
    @IBAction func btnCameraAction(_ sender: Any) {
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
        selectedLongitude = APP_DEL.selectedAddress.long
        selectedLatitude = APP_DEL.selectedAddress.lat
        selectedAddress = APP_DEL.selectedAddress.address
    }
}
extension CompanyEditProfileVC : UITextFieldDelegate, UITextViewDelegate {
  
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
extension CompanyEditProfileVC {
    
    func setUI(){
        
        txtmobile.delegate = self
        txtcomplayname.delegate = self
        txtabout.delegate = self
        txtworkinghours.delegate = self
        txtemail.delegate = self
        txtaddress.delegate = self
        
        let arrTemp = NSMutableArray()
        
        for i in 0..<APP_DEL.currentUser!.category!.count{
            self.selectedArr.add((APP_DEL.currentUser!.category![i].name!))
            arrTemp.add((APP_DEL.currentUser!.category![i].id!))
        }
        
        self.arrID = arrTemp
        selectedCat = arrTemp.componentsJoined(by: ",")
        txtCategory.text = self.selectedArr.componentsJoined(by: ",")
        
         if let imgUrl = APP_DEL.currentUser!.company_profile_image {
                        
                        imgprofile.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.user_placeholder), options: .refreshCached) { (img, err, _, _) in
                            //self.imgLogo.contentMode = .scaleAspectFill
                        }
                    }
        imgprofile.rounded()
        
        lbltital.text = APP_LBL.edit_profile
        lbltital.font = Utility.SetRagular(Utility.Header_Font_size())
        lbltital.textColor = APP_COL.APP_Black_Color
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lblcompanyname.text = APP_LBL.company_name_colon
        lblcompanyname.font = Utility.SetBlack(Utility.Small_size_14())
        lblcompanyname.textColor = APP_COL.APP_Black_Color
        
        txtcomplayname.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtcomplayname.textColor = APP_COL.APP_DarkGrey_Color
        
        companyview.backgroundColor = APP_COL.txtBGcolor
        companyview.roundView()
        
        lblCategory.text = APP_LBL.category
        lblCategory.font = Utility.SetBlack(Utility.Small_size_14())
        lblCategory.textColor = APP_COL.APP_Black_Color
        vwCategory.backgroundColor = APP_COL.txtBGcolor
        vwCategory.roundView()
        txtCategory.font = Utility.SetBlack(Utility.Small_size_14())
        txtCategory.textColor = APP_COL.APP_DarkGrey_Color
        
        lblabout.text = APP_LBL.about_colon
        lblabout.font = Utility.SetBlack(Utility.Small_size_14())
        lblabout.textColor = APP_COL.APP_Black_Color
        
        txtabout.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtabout.textColor = APP_COL.APP_DarkGrey_Color
        txtabout.backgroundColor = .clear
        
        aboutview.backgroundColor = APP_COL.txtBGcolor
        aboutview.roundView()
        
        lblhours.text = APP_LBL.working_hours_colon
        lblhours.font = Utility.SetBlack(Utility.Small_size_14())
        lblhours.textColor = APP_COL.APP_Black_Color
        
        txtworkinghours.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtworkinghours.textColor = APP_COL.APP_DarkGrey_Color
        
        hoursview.backgroundColor = APP_COL.txtBGcolor
        hoursview.roundView()
        
        lbladdress.text = APP_LBL.address_colon
        lbladdress.font = Utility.SetBlack(Utility.Small_size_14())
        lbladdress.textColor = APP_COL.APP_Black_Color
        
        txtaddress.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtaddress.textColor = APP_COL.APP_DarkGrey_Color
        
        addressview.backgroundColor = APP_COL.txtBGcolor
        addressview.roundView()
        
        lblemail.text = APP_LBL.email_address
        lblemail.font = Utility.SetBlack(Utility.Small_size_14())
        lblemail.textColor = APP_COL.APP_Black_Color
        
        txtemail.font = Utility.SetRagular(Utility.Small_size_12() + 2)
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
        lblcountrycode.font = Utility.SetSemiBold(Utility.Small_size_12() + 2)
        lblcountrycode.textColor = APP_COL.APP_Color
        
        txtmobile.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtmobile.textColor = APP_COL.APP_DarkGrey_Color
        
        mobileview.backgroundColor = APP_COL.txtBGcolor
        mobileview.roundView()
        
        btnsave.setTitle(APP_LBL.save, for: .normal)
        btnsave.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnsave.titleLabel?.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
        btnsave.backgroundColor = APP_COL.APP_Color
        btnsave.roundButton()
        
        
        txtcomplayname.text = APP_DEL.currentUser!.company_name!
        txtabout.text = APP_DEL.currentUser!.about!
        txtworkinghours.text = APP_DEL.currentUser!.working_hour!
        txtemail.text = APP_DEL.currentUser!.email!
       // txtCategory.text = APP_DEL.currentUser!.cate!
        txtaddress.text = APP_DEL.currentUser!.address!
        txtmobile.text = APP_DEL.currentUser!.mobile!
        
        selectedAddress = APP_DEL.currentUser!.address!
        selectedLatitude = APP_DEL.currentUser!.latitude!
        selectedLongitude = APP_DEL.currentUser!.longitude!
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//            if (textField == txtmobile) {
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
////        if string == " "{
////            return false
////        }
////
//            return true
//        }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        if text == " "{
//            return false
//        }
//
//        return true
//    }
}
//MARK:- GMSAutocompleteViewControllerDelegate
//extension CompanyEditProfileVC: GMSAutocompleteViewControllerDelegate {
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//
//
//        self.dismiss(animated: true, completion: nil)
//
//        selectedLatitude = String(format: "%0.7f", place.coordinate.latitude)
//        selectedLongitude = String(format: "%0.7f", place.coordinate.longitude)
//        selectedAddress = place.formattedAddress ?? ""
//        txtaddress.text = selectedAddress
//
////        if (isCitySelected){
////
////            NE = place.viewport?.northEast
////            SW = place.viewport?.southWest
////
////            room.ne_lat = String(format: "%0.7f", place.viewport!.northEast.latitude)
////            room.ne_long = String(format: "%0.7f", place.viewport!.northEast.longitude)
////            room.sw_lat = String(format: "%0.7f", place.viewport!.southWest.latitude)
////            room.sw_long = String(format: "%0.7f", place.viewport!.southWest.longitude)
////
////            txtCity.text = place.name
////            room.city = place.name ?? ""
////
////        } else {
////
////            txtAddress.text = place.formattedAddress
////            room.address = place.formattedAddress ?? ""
////            room.latitude = String(format: "%0.7f", place.coordinate.latitude)
////            room.longitude = String(format: "%0.7f", place.coordinate.longitude)
////        }
//    }
//
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        print("didFailAutocompleteWithError:- ", error.localizedDescription)
//    }
//
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        self.dismiss(animated: true, completion: nil)
//
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//}
extension String {
    var isReallyEmptyCEP : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
