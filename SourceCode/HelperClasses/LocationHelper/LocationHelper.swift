//
//  LocationHelper.swift
//  PetPack
//
//  Created by vishal.n on 19/05/20.
//  Copyright © 2020 Pratima. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

let LOCATION = LocationHelper.shared

class LocationHelper: NSObject {


    fileprivate var currentVC: UIViewController?
    fileprivate var isClearOldLocation: Bool = false
    
    let locationManager = CLLocationManager()
    var latitude : Double?
    var longitude : Double?
    var tempOldLat : Double = 0.0
    var tempOldLon : Double = 0.0
    
    
    static let shared: LocationHelper = {
        
        let instance = LocationHelper()
        return instance
    }()
    
    
    var didChangeAuthorization: ((_ res: Bool) -> Void)?
    var didUpdateLocations: ((_ lati: Double, _ long: Double) -> Void)?
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.distanceFilter = 10.0
        
        self.start()
    }

    func start() {
                
        self.locationManager.stopUpdatingLocation()
        
        if self.isClearOldLocation {
            
            self.tempOldLat = 0.0
            self.tempOldLon = 0.0
            
            self.latitude = nil
            self.longitude = nil
        }
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        print("startUpdatingLocation:- YES")
    }
    
    func stop() {
        
        self.locationManager.stopUpdatingLocation()
        print("stopUpdatingLocation:- YES")
    }
    
    func getLocationPermission(vc: UIViewController, isClearOldLocation: Bool) {
        
        self.currentVC = vc
        self.isClearOldLocation = isClearOldLocation
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            let status = CLLocationManager.authorizationStatus()
            
            switch status {
                
            case .notDetermined:
                APP_DEL.isLocationEnabled = false
                self.locationManager.requestLocation()
                self.locationManager.requestAlwaysAuthorization()

                break;
                
            case .denied, .restricted:
                APP_DEL.isLocationEnabled = false

                self.stop()
                
                let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
                
                let setting = UIAlertAction(title: "Settings", style: .default) { (ac) in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                alert.addAction(setting)
                
//                let cancel = UIAlertAction(title: "Cancel", style: .default) { (ac) in
//                    self.currentVC?.navigationController?.popViewController(animated: true)
//                }
//                alert.addAction(cancel)
                
                currentVC?.present(alert, animated: true, completion: nil)
                
                break;
                
            case .authorizedAlways, .authorizedWhenInUse:
                APP_DEL.isLocationEnabled = true

                self.didChangeAuthorization?(true)
                self.currentVC = nil
                            
//                if !APP_DEL.isLocationSelected() || APP_DEL.selectedAddress.lat == "0.0"{
//                    self.start()
//                }
                

                break;
                
            default:
                APP_DEL.isLocationEnabled = false

                break;
            }
            
        } else {
            
            currentVC?.showAlert(message: "Please enable location service..!")
        }
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let tempLoc = locations.first else {
            return;
        }
        
        self.latitude = tempLoc.coordinate.latitude
        self.longitude = tempLoc.coordinate.longitude
        self.didUpdateLocations?(tempLoc.coordinate.latitude, tempLoc.coordinate.longitude)
//        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
            case .notDetermined, .restricted, .denied:
                                
                guard let vc = self.currentVC else {
                    return;
                }
                self.getLocationPermission(vc: vc, isClearOldLocation: self.isClearOldLocation)
                
                break
            
            case .authorizedWhenInUse, .authorizedAlways:
                
//                self.start()
                
                self.didChangeAuthorization?(true)
                self.currentVC = nil
                break
            
            default:
                
                self.didChangeAuthorization?(false)
                break
            
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("didFailWithError:- ", error.localizedDescription)
    }
}


extension LocationHelper {
    
    func getAddress(lat: Double, long: Double, completion: @escaping (CLPlacemark?, String?) -> Void ) {
                
        let geocoder = CLGeocoder()
            
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long), completionHandler: { (placemarks, error) in
            
            if error == nil {
                
                let firstLocation = placemarks?[0]
                completion(firstLocation, nil)
                
            } else {
             
                completion(nil, error?.localizedDescription)
            }
        })
    }
    
    func getLocation(address: String, completion: @escaping(CLLocationCoordinate2D?, String?) -> Void ) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            if error == nil {
                
                if let placemark = placemarks?[0] {
                    
                    let location = placemark.location!
                        
                    completion(location.coordinate, nil)
                    return
                }
            }
                
            completion(nil, error?.localizedDescription)
        }
    }
}
