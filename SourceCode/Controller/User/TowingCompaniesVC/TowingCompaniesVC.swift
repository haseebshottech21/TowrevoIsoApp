//
//  TowingCompaniesVC.swift
//  SourceCode
//
//  Created by Yesha on 11/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import GoogleMaps

class TowingCompaniesVC: BaseVC {
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnList: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var btnmapback: UIButton!
    @IBOutlet var btnDetail: UIButton!
    @IBOutlet weak var tblTowingCompanies: UITableView!
    @IBOutlet weak var toolbarview: UIView!
    
    @IBOutlet weak var lblLine: UILabel!
    
    @IBOutlet var vwMainView: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTimings: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnGetDirection: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    var arrMarkerArray = [GMSMarker]()
    var page_no : Int = 1
    var catID = String()
    var address = String()
    var latitude = String()
    var longitude = String()
    
    var companyMod : CompanyListModel?
    var companyList : [CompanyList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRefreshController(scrollView: self.tblTowingCompanies)
        self.getCompantList(isClear: true, isProgress: true)
        btnList.isHidden = true
        mapView.isHidden = true
        
        //btnFilter.isHidden = false
        btnList.isHidden = true
        //mapView.isHidden = true
        tblTowingCompanies.isHidden = false
        toolbarview.isHidden = false
        lblLine.isHidden = false
        
        setUI()
        self.loadMapMarker()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    @IBAction func btnDetailAction(_ sender: Any) {
        self.vwMainView.isHidden = true
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "TowingServiceCompanyVC") as! TowingServiceCompanyVC
        vc.arrService = companyList[(sender as AnyObject).tag]
        vc.address = address
        vc.latitude = latitude
        vc.longitude = longitude
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLocationAction(_ sender: Any) {
        self.loadMapMarker()
    }
    @IBAction func btnDirection(_ sender: Any){
        let dict = companyList[(sender as AnyObject).tag]
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(dict.place?.latitude! ?? ""),\(dict.place?.longitude! ?? "")&directionsmode=driving")! as URL)
        } else
        {
            UIApplication.shared.openURL(NSURL(string:
                "https://apps.apple.com/us/app/google-maps-transit-food/id585027354")! as URL)
            NSLog("Can't use com.google.maps://");
        }
    }
    @IBAction func CallCompany(_ sender: Any)
    {
        let dataTowing = companyList[(sender as AnyObject).tag]
        
        //UIApplication.shared.openURL(URL(string: "tel://\(dataTowing.phoneNum)")! as URL)
      //  UIApplication.shared.openURL(URL(string: "tel://" + dataTowing.mobile!)! as URL)
        //tblTowingCompanies.reloadData()
        
        if let url = NSURL(string: "tel://\(dataTowing.mobile!)"), UIApplication.shared.canOpenURL(url as URL) {
           
        UIApplication.shared.openURL(url as URL)
              }else
              {
                  showAlert(message: "Invalid number")
              }
    }
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDismissInfoView(_ sender: Any) {
        self.vwMainView.isHidden = true
    }
    @objc func refreshList(noti: Notification) {
        
        self.refreshCalled(res: true)
    }
    override func refreshCalled(res: Bool) {
        
        self.getCompantList(isClear: true, isProgress: false)
    }
    func checkNoData() {
        
        if self.companyList.count  == 0 {
            self.setNoData(scrollView: self.tblTowingCompanies)
        } else {
            self.tblTowingCompanies.delegate = self
            self.tblTowingCompanies.dataSource = self
        }
        
        self.tblTowingCompanies.reloadData()
        self.refreshView.endRefreshing()
    }
    func checkPagination() {
        
        if Int(self.companyMod?.total_count ?? 0) > self.companyList.count {
            
            print("GET MORE PAGE")
            self.page_no = self.page_no + 1
            self.getCompantList(isClear: false, isProgress: true)
        } else {
            print("NO MORE PAGE")
        }
    }
    
    
    func getCompantList(isClear: Bool, isProgress: Bool) {
        
        if isProgress {
            self.showProgressHUD()
        }
        if isClear {
            self.page_no = 1
        }
        //towrevo.vrinsoft.in/api/CompanyList?user_id=51&category_id=1&latitude=23.018940&longitude=72.541512&token=e9ee988ca17cff4492456a6a8f708219&address=Ambawadi,Ahmedabad,Gujarat,India&page=1
        let par : [String : String] = [
            "user_id" : APP_DEL.currentUser!.user_id!,
            "user_type" : APP_DEL.currentUser!.user_type!,
            "category_id" : catID,
            "latitude" : latitude,
            "longitude" : longitude,
            "token" : APP_DEL.currentUser!.token!,
            "address" : address,
            "page" : "\(self.page_no)"
        ]
        
        
        API.CompanyList(param: par) { (notMod, mess) in
            
            if isProgress {
                self.hideProgressHUD()
            }
            
            if mess == nil && notMod != nil {
                
                if isClear {
                    
                    self.companyMod = nil
                    self.companyList = []
                }
                
                self.companyMod = notMod
                
                if self.companyList.count == 0 {
                    self.companyList = notMod?.data! ?? []
                } else {
                    self.companyList.append(contentsOf: (notMod?.data! ?? []) as [CompanyList])
                }
                
            } else {
                
                if isProgress {
                    self.hideProgressHUD()
                }
                self.companyMod = nil
                self.companyList = []
                
                if notMod?.code != 0  && notMod?.code != -7{
                    if isProgress {
                        self.showAlert(message: mess ?? "")
                    }
                }
            }
            self.checkNoData()
            
            self.tblTowingCompanies.reloadData()
        }
    }
    @IBAction func btnMapBackAction(_ sender: Any) {
        btnFilter.isHidden = false
        btnList.isHidden = true
        mapView.isHidden = true
        tblTowingCompanies.isHidden = false
        toolbarview.isHidden = false
        lblLine.isHidden = false
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterAction(_ sender: UIButton) {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        //        //vc.arrInquiryDetails = arrmyinquiry[indexPath.row]
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if companyList.count <= 0
        {
            showAlert(message: APP_LBL.no_data_available_at_selected_location)
        } else
        {
            btnFilter.isHidden = true
            tblTowingCompanies.isHidden = true
            toolbarview.isHidden = true
            btnList.isHidden = false
            mapView.isHidden = false
            lblLine.isHidden = true
            self.loadMapMarker()
        }
    }
    
    @IBAction func btnListAction(_ sender: Any) {
        btnFilter.isHidden = false
        btnList.isHidden = true
        mapView.isHidden = true
        tblTowingCompanies.isHidden = false
        toolbarview.isHidden = false
        lblLine.isHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}

extension TowingCompaniesVC {
    
    func setUI(){
        
        let nib = UINib(nibName: "TowingCompaniesTableViewCell", bundle: nil)
        tblTowingCompanies.register(nib, forCellReuseIdentifier: "TowingCompaniesTableViewCell")
        tblTowingCompanies.delegate = self
        tblTowingCompanies.dataSource = self
        tblTowingCompanies.reloadData()
        
        lblTitle.text = APP_LBL.towing_companies
        lblTitle.font = Utility.SetSemiBold(Utility.Header_Font_size())
        lblTitle.textColor = APP_COL.APP_Black_Color
        
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        btnmapback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        vwMainView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.view.addSubview(vwMainView)
        vwMainView.isHidden = true
        
        viewContent.backgroundColor = APP_COL.APP_Faded_White
        viewContent.roundCorner(value: 15.0)
        viewContent.layer.borderWidth = 1.0
        viewContent.layer.borderColor = (APP_COL.APP_Color).cgColor
        
        lblTimings.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        lblTimings.textColor = APP_COL.APP_LabelGrey
        
        lblDistance.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        
        
        lblCompanyName.font = Utility.SetBold(Utility.Header_Font_size() + 2)
        lblCompanyName.textColor = APP_COL.APP_Black_Color
        
        lblDescription.font = Utility.SetRagular(Utility.Small_size_12())
        lblDescription.textColor = APP_COL.APP_Black_Color
        
        btnGetDirection.setTitle(APP_LBL.get_direction, for: .normal)
        btnGetDirection.titleLabel?.font = Utility.SetBold(Utility.Small_size_12())
        btnGetDirection.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        imgLogo.round()
    }
}

extension TowingCompaniesVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return companyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TowingCompaniesTableViewCell", for: indexPath) as! TowingCompaniesTableViewCell
        
        let towingData = companyList[indexPath.row]
        if indexPath.row == (self.companyList.count - 3) {
            
            self.checkPagination()
        }
        cell.selectionStyle = .none
        cell.lblTimings.text = towingData.working_hours
        cell.lblDistance.text = "(" + towingData.distance! + " " + APP_LBL.distance_unit + ")" 
        cell.lblCompanyName.text = towingData.company_name
        cell.lblDescription.text = towingData.company_details
        cell.btnGetDirection.tag = indexPath.row
        cell.btnGetDirection.addTarget(self, action: #selector(btnDirection(_:)), for: .touchUpInside)
        cell.btnCall.tag = indexPath.row
        cell.btnCall.addTarget(self, action: #selector(CallCompany(_:)), for: .touchUpInside)
        
        if let imgUrl = towingData.company_profile_image {
            
            cell.imgLogo.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                cell.imgLogo.contentMode = .scaleAspectFill
            }
        } else {
            
            cell.imgLogo.image = UIImage.init(named: APP_IMG.img_placeholder)
            cell.imgLogo.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "TowingCompaniesTableViewCell", for: indexPath) as! TowingCompaniesTableViewCell
        //print(indexPath.row)
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "TowingServiceCompanyVC") as! TowingServiceCompanyVC
        vc.arrService = companyList[indexPath.row]
        vc.address = address
        vc.latitude = latitude
        vc.longitude = longitude
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension TowingCompaniesVC : GMSMapViewDelegate {
    func loadMapMarker() {
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        DispatchQueue.main.async {
            var infoView : MarkerInfo = MarkerInfo()
            if let temp = MarkerInfo.initWith(owner: self) {
                infoView = temp
            }
            var bounds = GMSCoordinateBounds()
            for index in 0..<self.companyList.count {
            
                let rec = self.companyList[index]
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(rec.place?.latitude ?? "0.0")!, longitude: Double(rec.place?.longitude ?? "0.0")!))
                
//                //   marker.icon = UIImage.init(named: "marker")
//                var view : MarkerInfo = MarkerInfo()
//                 view = Bundle.main.loadNibNamed("MarkerInfo", owner: nil, options: nil)?.first as! MarkerInfo
//              //  view.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
//                view.lblTitle.font = Utility.SetBold(Utility.Small_size_12())
//                view.lblTitle.textColor = APP_COL.APP_Color
//                view.lblTitle.text = rec.company_name
//                view.layoutIfNeeded()
//
////                UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
////                view.layer.render(in: UIGraphicsGetCurrentContext()!)
////                let imageConverted: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
////                UIGraphicsEndImageContext()
//
//
//                    view.layoutIfNeeded()
//
//                let renderer = UIGraphicsImageRenderer(bounds: view.vwConatainer.bounds)
//                        let imageConverted = renderer.image { rendererContext in
//                            view.vwConatainer.layer.render(in: rendererContext.cgContext)
//                        }
//
//
//
//
//
//
//
//
//                //   self.view.addSubview(view)
//                marker.appearAnimation = GMSMarkerAnimation.none
//             //   marker.iconView = view
//                marker.icon = imageConverted
//                marker.opacity = 1.0
//                marker.isFlat = true
//                marker.infoWindowAnchor = CGPoint(x: 0.44, y: 0.45);
//                marker.map = self.mapView
                marker.accessibilityLabel = "\(index)"
                 infoView.setup(title: rec.company_name!, color: APP_COL.APP_Color, icon: UIImage(named: "marker")!)
                marker.icon = infoView.snapShot()
                marker.map = self.mapView
                
                bounds = bounds.includingCoordinate(marker.position)
               // marker.position = self.mapView.camera.target
            }
           
            //self.mapView.settings.zoomGestures = false
            
            // DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: (self.mapView?.frame.height)!/2 + 50, left: (self.mapView?.frame.width)!/2 - 81, bottom: 0, right: 0))
           // let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
         self.mapView!.moveCamera(update)
            
            
            //  }
        }
        
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }

    func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        print("Drag")
    }

    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("Zoom")
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let index = Int(marker.accessibilityLabel ?? "-1")!
        print("mapView didTap marker:- ", index)
        
        if index > -1 {

            
            let newCamera = GMSCameraUpdate.setCamera(GMSCameraPosition(latitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 14.0))
            self.mapView.animate(with: newCamera)
            self.vwMainView.isHidden = false
            
            let towingData = companyList[index]
            
            lblTimings.text = towingData.working_hours
            lblDistance.text = "(" + towingData.distance! + " " + APP_LBL.distance_unit + ")"
            lblCompanyName.text = towingData.company_name
            lblDescription.text = towingData.company_details
            btnGetDirection.tag = index
            btnCall.tag = index
            btnDetail.tag = index
            if let imgUrl = towingData.company_profile_image {
                
                imgLogo.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                    self.imgLogo.contentMode = .scaleAspectFill
                }
            } else {
                
                imgLogo.image = UIImage.init(named: APP_IMG.img_placeholder)
                imgLogo.contentMode = .scaleAspectFill
            }
            
        }
        
        return true;
    }
   
    
}
