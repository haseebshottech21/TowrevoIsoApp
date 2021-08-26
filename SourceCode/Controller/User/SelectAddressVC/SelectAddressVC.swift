//
//  SelectAddressVC.swift
//  2Secure
//
//  Created by vishal.n on 16/12/20.
//  Copyright © 2020 Jayesh Dabhi. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SDWebImage
protocol AddEditAddress {
    func addEditAddress(res: Bool, adddress: Address, addressID: String)
}
class SelectAddressVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var viewNoMap: UIView!
    
    @IBOutlet weak var viewBottomBtnShadow: UIButton!
    
    @IBOutlet weak var indicatorAddress: UIActivityIndicatorView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnCurrent: UIButton!
    
    var delegateAddEditAddress: AddEditAddress?
    
//    var isFromOTP : Bool = false
    
    var address = Address()
    var addressID = ""
    
    var isIdleEnabled = false
    var isUpdateZoom = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showProgressHUD()
        
        self.map.isHidden = true
        setUI()
        GetLocation(isCurrent: false)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
         return .default
       }
    
    func GetLocation(isCurrent : Bool) {
        if isCurrent {
            self.CurrentLocation()
        }else{
            self.addressID = self.address.id
            
            
            self.hideTabbar()
            
            
            LOCATION.didChangeAuthorization = { (res) in
                if !res {
                    self.willEnterForeground()
                }
            }
            
            if self.address.lat == "0.0" || self.address.long == "0.0" || self.address.lat == ""  ||  self.address.long == "" {
                
                if self.address.lat == "" || self.address.lat == "0.0"{
                    LOCATION.start()
                }
                
                var isNewAddressCalled = false
                
                LOCATION.didUpdateLocations = { (lati, long) in
                    
                    print("LOCATION:- ", lati,long)
                    if ((LOCATION.tempOldLat != lati) || (LOCATION.tempOldLon != long)) {
                        
                        print("LOCATION:- PASS", lati,long)
                        LOCATION.tempOldLat = lati
                        LOCATION.tempOldLon = long
                        
                        if self.address.address == "" || self.address.lat == "0.0" || self.address.long == "0.0" {
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
                if self.address.lat == "0.0" || self.address.lat == "" {

                    self.updateMapAndAddress(location: CLLocationCoordinate2D(latitude: Double(APP_DEL.selectedAddress.lat) ?? 0.0, longitude: Double(APP_DEL.selectedAddress.long) ?? 0.0))

                }else{

                    self.updateMapAndAddress(location: CLLocationCoordinate2D(latitude: Double(self.address.lat) ?? 0.0, longitude: Double(self.address.long) ?? 0.0))

                    
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
    }}
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.willEnterForeground()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func willEnterForeground() {
        
        LOCATION.getLocationPermission(vc: self, isClearOldLocation: false)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateCurrentLocaion(lat: Double, long: Double, isClear: Bool) {
        
        if isClear {
            map.clear()
        }
        
        CATransaction.begin()
        
        map.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17)
        
        let currentLocMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
        currentLocMarker.appearAnimation = GMSMarkerAnimation.none
        currentLocMarker.icon = UIImage(named: "current_loc")
        currentLocMarker.opacity = 1.0
        currentLocMarker.isFlat = true
        currentLocMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        currentLocMarker.map = map
        
        currentLocMarker.appearAnimation = GMSMarkerAnimation.pop
        
        CATransaction.commit()
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        isUpdateZoom = false
        if LOCATION.latitude == nil || LOCATION.longitude == nil {
            
            LOCATION.getLocationPermission(vc: self, isClearOldLocation: false)
            
        } else {
            
            self.showPlacePicker()
        }
    }
    
    @IBAction func btnSelectAction(_ sender: UIButton) {
        
        APP_DEL.selectedAddress = self.address
      //  APP_DEL.selectedAddress.syncronize()
        self.delegateAddEditAddress?.addEditAddress(res: true, adddress: self.address, addressID: self.addressID)
        self.navigationController?.popViewController(animated: true)
    
    }
    
    
    
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAddressProgress() {
        
        self.indicatorAddress.startAnimating()
        self.indicatorAddress.isHidden = false
        self.indicatorAddress.superview?.isHidden = false
    }
    
    func hideAddressProgress() {
        
        self.indicatorAddress.stopAnimating()
        self.indicatorAddress.isHidden = true
        self.indicatorAddress.superview?.isHidden = true
    }
    
    
    func showPlacePicker() {
        
        let picker = GMSAutocompleteViewController()
        picker.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.address
        picker.autocompleteFilter = filter
        
        picker.modalPresentationStyle = .overFullScreen
        picker.modalTransitionStyle = .crossDissolve
        self.present(picker, animated: true) { }
    }
    
    
    var passCordinate: CLLocationCoordinate2D? = nil
    func updateMapAndAddress(location: CLLocationCoordinate2D) {
        
        passCordinate = location
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalCallUpdateMapAndAddress), object: nil)
        self.perform(#selector(finalCallUpdateMapAndAddress), with: nil, afterDelay: 1)
    }
    
    @objc func finalCallUpdateMapAndAddress() {
        
        guard let location = passCordinate else { return }
        
        self.showAddressProgress()
        self.showProgressHUD()
        
        LOCATION.stop()
        GMS.getGeocodeAddress(location: location) { (geocodeMod, err) in
            
            self.hideAddressProgress()
            
            if err == nil {
                
                let add = geocodeMod?.results?.first?.getAddress()
                
                let addr = Address()
                
                //here set old address id for replace in arrPoint
                addr.id = self.addressID
                
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
        
        self.address = ad
        
        self.lblAddress.text = self.address.address
        
        let lat = Double(ad.lat) ?? 0.0
        let long = Double(ad.long) ?? 0.0
        
        self.map.clear()
        
        if isUpdateZoom {
            self.map.animate(to: GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: self.map.camera.zoom))
        }else{
            self.map.animate(to: GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 18))
            isUpdateZoom = true
        }
        self.hideProgressHUD()
        self.map.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
        
            self.viewNoMap.isHidden = true
        }
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isIdleEnabled = true
            print("isIdleEnabled:- ", "TRUE")
        }
        
    }
    
    
    
    @IBAction func actionBtnCurrent(_ sender: UIButton) {
        GetLocation(isCurrent: true)
    }
    
    
    
}

extension SelectAddressVC {
    
    func setUI() {
        
        self.map.delegate = self
        
        btnCurrent.layer.cornerRadius = btnCurrent.frame.size.height/2
        btnCurrent.clipsToBounds = true
        
        lblTitle.font = Utility.SetSemiBold(Utility.Header_Font_size())
        lblTitle.text = APP_LBL.select_location
        
        viewBottom.roundCorner(value: 18)
        viewBottomBtnShadow.roundCorner(value: 18)
        viewBottomBtnShadow.backgroundColor = .black
        
//         viewBottomBtnShadow.shadow(shadowColor: .lightGray, offSet: CGSize(width: 0, height: 0), opacity: 0.3, shadowRadius: 5)
//        lblAddress.superview?.cornerRadius(cornerRadius: 4, clipsToBounds: true)
//        lblAddress.superview?.border(borderWidth: 1, borderColor: UIColor.lightGray)
   
        lblAddress.font = Utility.SetRagular(Utility.TextField_Font_size())
        
        lblAddress.text = address.address
        
        
        btnSelect.setTitle(APP_LBL.done, for: .normal)
        btnCancel.setTitle(APP_LBL.cancel, for: .normal)
        btnSelect.titleLabel?.font = Utility.SetSemiBold(Utility.Header_Font_size())
        btnCancel.titleLabel?.font = Utility.SetSemiBold(Utility.Header_Font_size())
        
        
        btnSelect.backgroundColor = UIColor.white
        btnCancel.backgroundColor = UIColor.white
        
    
    }
}

extension SelectAddressVC: GMSAutocompleteViewControllerDelegate {
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if self.isIdleEnabled {
            self.isIdleEnabled = false
            
            self.updateMapAndAddress(location: place.coordinate)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension SelectAddressVC: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if self.isIdleEnabled {
            self.isIdleEnabled = false
            
            self.updateMapAndAddress(location: position.target)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if self.isIdleEnabled {
            self.isIdleEnabled = false
            
            self.updateMapAndAddress(location: coordinate)
        }
    }
}
