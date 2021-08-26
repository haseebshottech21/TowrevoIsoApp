//
//  MapVC.swift
//  SourceCode
//
//  Created by Yesha on 20/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import GoogleMaps
class MapVC: BaseVC {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var btnlist: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set initial location in Honolulu
        //let initialLocation =
//            mapview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            mapview.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), animated: false)

        // Do any additional setup after loading the view.
        
        
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    override func viewWillAppear(_ animated: Bool) {
       hideNavigationBar()
    }
    
   
    @IBAction func btnListAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//extension MapVC {
//  func centerToLocation(
//    _ location: CLLocation,
//    regionRadius: CLLocationDistance = 1000
//  ) {
//    let coordinateRegion = MKCoordinateRegion(
//      center: location.coordinate,
//      latitudinalMeters: regionRadius,
//      longitudinalMeters: regionRadius)
//    s(coordinateRegion, animated: true)
//  }
//}
