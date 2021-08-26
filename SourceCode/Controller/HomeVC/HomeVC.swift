//
//  HomeVC.swift
//  SourceCode
//
//  Created by Yesha on 11/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class HomeVC: BaseVC, interestedDelegate, UITextFieldDelegate, AddEditAddress{
    
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var viewPickUpLocation: UIView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    
    var selectedCat = String()
    var isValidated = true
    
    var categoryMod : categoryModel?
    var categoryList : [category] = []
    var arrID = NSMutableArray()
    
    var passCordinate: CLLocationCoordinate2D? = nil
    
    var selectedLatitude = ""
    var selectedLongitude = ""
    var selectedAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoryList()
        self.GetLocation(isCurrent: true)
        setUI()
        
        txtCategory.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
               
               self.willEnterForeground()
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
    @IBAction func btnCategoryAction(_ sender: Any) {
         let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "InterestedVC") as! InterestedVC
               vc.delegate = self
        vc.arrId = arrID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        vc.modalPresentationStyle = .overFullScreen
        vc.parentVc = self
        self.present(vc, animated: false, completion: nil)

       
    }
    
    @IBAction func btnLocationAction(_ sender: Any)
    {
        
        let vc : SelectAddressVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
        vc.address = APP_DEL.selectedAddress
        vc.delegateAddEditAddress = self
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    //{
//        let placepicker = GMSAutocompleteViewController()
//        placepicker.delegate = self
//
//        let filter = GMSAutocompleteFilter()
//        filter.type = GMSPlacesAutocompleteTypeFilter.address
//
//        placepicker.autocompleteFilter = filter
//        self.present(placepicker, animated: true, completion: nil)
  //  }
    
    @IBAction func btnNextAction(_ sender: Any) {
        
        guard let location = txtLocation.text, let category = txtCategory.text else {
            return
        }
        
        if location.isEmpty {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_location)
        } else if (category.isEmpty) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_select_category)
            
        } else if selectedCat == "" {
            
            isValidated = false
            showAlert(message: APP_LBL.please_select_category)
        } else {
            
            isValidated = true
            moveToNetScreen()
        }
        
    }
    
    func moveToNetScreen(){
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "TowingCompaniesVC") as! TowingCompaniesVC
        vc.catID = selectedCat
        vc.latitude = APP_DEL.selectedAddress.lat
        vc.longitude = APP_DEL.selectedAddress.long
        vc.address = APP_DEL.selectedAddress.address
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getCategoryList() {
        //towrevo.vrinsoft.in/api/towCategory?user_id=40&token=16a50d6c3580363c1aefaad06d834232&user_type=2
        
        let par : [String : String] = [
            "user_id" : APP_DEL.currentUser!.user_id!,
            "user_type" : APP_DEL.currentUser!.user_type!,
            "token" : APP_DEL.currentUser!.token!,
        ]
        
        
        API.towCategory(param: par) { (notMod, mess) in
            
            if mess == nil && notMod != nil {
            
                self.categoryMod = notMod
                
                if self.categoryList.count == 0 {
                    self.categoryList = notMod?.data! ?? []
                } else {
                    self.categoryList.append(contentsOf: (notMod?.data! ?? []) as [category])
                }
                
            } else {
                self.categoryMod = nil
                self.categoryList = []
                
                if notMod?.code != 0 {
                }
            }
        }
    }
    
    func addEditAddress(res: Bool, adddress: Address, addressID: String)
    {
        txtLocation.text = APP_DEL.selectedAddress.address
    }
}


extension HomeVC {
    
    func setUI(){
        
        btnMenu.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        viewContent.roundCorner(value: 15.0)
        viewContent.layer.masksToBounds = false
        viewContent.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        viewContent.layer.shadowOpacity = 0.5
        viewContent.layer.shadowOffset = CGSize.zero
        viewContent.layer.shadowRadius = 5.0
        
        viewContent.layer.shouldRasterize = true
        viewContent.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        viewPickUpLocation.roundView()
        //viewPickUpLocation.layer.borderWidth = 0.2
        viewPickUpLocation.backgroundColor = APP_COL.txtBGcolor
        //viewPickUpLocation.layer.borderColor = (APP_COL.APP_Black_Color).cgColor
        
        viewCategory.roundView()
        viewCategory.backgroundColor = APP_COL.txtBGcolor
//        viewCategory.layer.borderWidth = 0.2
//        viewCategory.layer.borderColor = (APP_COL.APP_Black_Color).cgColor
        
        
        lblPickUpLocation.text = APP_LBL.pickup_location
        lblPickUpLocation.font = Utility.SetSemiBold(Utility.Header_Font_size() + 2)
        lblPickUpLocation.textColor = APP_COL.APP_Black_Color
        
        lblCategory.text = APP_LBL.category
        lblCategory.font = Utility.SetBlack(Utility.Header_Font_size() + 2)
        lblCategory.textColor = APP_COL.APP_Black_Color
        
        txtCategory.font = Utility.SetBlack(Utility.Small_size_14())
        txtCategory.textColor = APP_COL.APP_DarkGrey_Color
        
        txtCategory.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        txtCategory.textColor = APP_COL.APP_Black_Color
        
        txtLocation.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        txtLocation.textColor = APP_COL.APP_Black_Color
        txtLocation.layer.borderWidth = 0.0
        
        btnNext.setTitle(APP_LBL.next, for: .normal)
        btnNext.titleLabel?.font = Utility.SetBlack(Utility.Header_Font_size() + 2)
        btnNext.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnNext.backgroundColor = APP_COL.APP_Color
        btnNext.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btnNext.layer.shadowOffset = CGSize.zero
        btnNext.layer.shadowOpacity = 0.5
        btnNext.layer.shadowRadius = 10.0
        btnNext.layer.masksToBounds = false
        btnNext.roundCorner(value: 4.0)
              // btnlogin.roundButton()
            
        
    }
}




////MARK:- GMSAutocompleteViewControllerDelegate
//extension HomeVC: GMSAutocompleteViewControllerDelegate {
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//   
//  
//        self.dismiss(animated: true, completion: nil)
//        
//        selectedLatitude = String(format: "%0.7f", place.coordinate.latitude)
//        selectedLongitude = String(format: "%0.7f", place.coordinate.longitude)
//        selectedAddress = place.formattedAddress ?? ""
//        txtLocation.text = selectedAddress
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

extension HomeVC
{
        func GetLocation(isCurrent : Bool) {
            if isCurrent {
                self.CurrentLocation()
            }else{
               // self.addressID = self.address.id
                
                
                self.hideTabbar()
                
                
                LOCATION.didChangeAuthorization = { (res) in
                    if !res {
                        self.willEnterForeground()
                    }
                }
                
                if APP_DEL.selectedAddress.lat == "0.0" || APP_DEL.selectedAddress.long == "0.0" || APP_DEL.selectedAddress.lat == ""  ||  APP_DEL.selectedAddress.long == "" {
                    
                    if APP_DEL.selectedAddress.lat == "" || APP_DEL.selectedAddress.lat == "0.0"{
                        LOCATION.start()
                    }
                    
                    var isNewAddressCalled = false
                    
                    LOCATION.didUpdateLocations = { (lati, long) in
                        
                        print("LOCATION:- ", lati,long)
                        if ((LOCATION.tempOldLat != lati) || (LOCATION.tempOldLon != long)) {
                            
                            print("LOCATION:- PASS", lati,long)
                            LOCATION.tempOldLat = lati
                            LOCATION.tempOldLon = long
                            
                            if APP_DEL.selectedAddress.address == "" || APP_DEL.selectedAddress.lat == "0.0" || APP_DEL.selectedAddress.long == "0.0" {
                                isNewAddressCalled = true
                                self.updateMapAndAddress(location: CLLocationCoordinate2D(latitude: lati, longitude: long))
                            }else{
                                self.updateMapAndAddress(location: CLLocationCoordinate2D(latitude: lati, longitude: long))

                            }
                            return;
                        }
                        
                        if isNewAddressCalled == false {
                            LOCATION.stop()
                            isNewAddressCalled = true
                            self.updateMapAndAddress(location: CLLocationCoordinate2D(latitude: lati, longitude: long))
                        }
                    }
                    
                    
                    
                } else {
                    if APP_DEL.selectedAddress.lat == "0.0" || APP_DEL.selectedAddress.lat == "" {

                        self.updateMapAndAddress(location: CLLocationCoordinate2D(latitude: Double(APP_DEL.selectedAddress.lat) ?? 0.0, longitude: Double(APP_DEL.selectedAddress.long) ?? 0.0))

                    }else{

                        self.updateMapAndAddress(location: CLLocationCoordinate2D(latitude: Double(APP_DEL.selectedAddress.lat) ?? 0.0, longitude: Double(APP_DEL.selectedAddress.long) ?? 0.0))

                        
                    }
                    

                    
                }
            }
        }
        
        
        func CurrentLocation(){
            
            self.showProgressHUD()
            LOCATION.start()
            
            LOCATION.didUpdateLocations = { (lati, long) in
            
            print("didUpdateLocations:- ", lati,long)
            
            if ((LOCATION.tempOldLat != lati) || (LOCATION.tempOldLon != long)) {
                
                print("LOCATION:- PASS", lati,long)
                LOCATION.tempOldLat = lati
                LOCATION.tempOldLon = long
                self.hideProgressHUD()

    //            let location = CLLocationCoordinate2D(latitude: Double(LOCATION.tempOldLat), longitude: Double(LOCATION.tempOldLon))
                
                self.updateMapAndAddress(location: CLLocationCoordinate2D(latitude: lati, longitude: long))

                
                
            }
                self.hideProgressHUD()
        }}

    @objc func willEnterForeground() {
        
        LOCATION.getLocationPermission(vc: self, isClearOldLocation: false)
    }
    
    
    func updateMapAndAddress(location: CLLocationCoordinate2D) {
        
        passCordinate = location
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalCallUpdateMapAndAddress), object: nil)
        self.perform(#selector(finalCallUpdateMapAndAddress), with: nil, afterDelay: 1)
    }
    
    @objc func finalCallUpdateMapAndAddress() {
        
        guard let location = passCordinate else { return }
        
    
        self.showProgressHUD()
        
        LOCATION.stop()
        GMS.getGeocodeAddress(location: location) { (geocodeMod, err) in
            
          
            
            if err == nil {
                
                let add = geocodeMod?.results?.first?.getAddress()
                
                let addr = Address()
                
                //here set old address id for replace in arrPoint
                
                addr.lat = "\(String(format: "%.6f", Double(add?.latitude ?? "0.0") ?? 0.0))"//add?.latitude ?? ""
                addr.long = "\(String(format: "%.6f", Double(add?.longitude ?? "0.0") ?? 0.0))"//add?.longitude ?? ""
                addr.street = add?.street_number ?? ""
                addr.block = add?.block ?? ""
                addr.society = add?.socity_area ?? ""
                addr.postal_code = add?.postal_code ?? ""
                addr.city = add?.city ?? ""
                addr.address = add?.address ?? ""
                
                
                let MainAddress = Addresslist(address_id: "", user_id: APP_DEL.currentUser?.user_id ?? "", house: add?.block ?? "", landmark: String(format: "%@ %@",add?.street_number ?? "" ,add?.socity_area ?? ""), city: add?.city ?? "", district: add?.city ?? "", zipcode: add?.postal_code ?? "", address_type: "", latitude: add?.latitude ?? "0.0", longitude: add?.longitude ?? "0.0", is_default: "", address: add?.address ?? "")
                 
                self.updateDetail(ad: addr)
                
            } else {
                self.hideProgressHUD()
                self.showAlert(message: "Not found any address")
            }
        }
    }
    
    func updateDetail(ad: Address) {
        
        APP_DEL.selectedAddress = ad
        self.txtLocation.text = APP_DEL.selectedAddress.address
        
        
        self.hideProgressHUD()
       


        
    }
}
