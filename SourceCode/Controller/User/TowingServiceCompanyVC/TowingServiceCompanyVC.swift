//
//  TowingServiceCompanyVC.swift
//  SourceCode
//
//  Created by Yesha on 11/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class TowingServiceCompanyVC: BaseVC {

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblAboutTitle: UILabel!
    @IBOutlet weak var lblAboutValue: UILabel!
    @IBOutlet weak var lblContactTitle: UILabel!
    @IBOutlet weak var lblAddressValue: UILabel!
    @IBOutlet weak var btnGetDirection: UIButton!
    @IBOutlet weak var btnSendEnquiry: UIButton!
    
    @IBOutlet weak var btnContactNumValue: UIButton!
    
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblSeperatorEmail: UILabel!

    
    var address = String()
    var latitude = String()
    var longitude = String()
    
    var arrService : CompanyList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEmail.isHidden = true
        imgEmail.isHidden = true
        lblSeperatorEmail.isHidden = true
        
        print(self.arrService!)
        setUI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       hideNavigationBar()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
        {
        return .default
    }
    @IBAction func btnGetDirection(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(arrService.place?.latitude! ?? ""),\(arrService.place?.longitude! ?? "")&directionsmode=driving")! as URL)
        } else
        {
            UIApplication.shared.openURL(NSURL(string:
            "https://apps.apple.com/us/app/google-maps-transit-food/id585027354")! as URL)
            NSLog("Can't use com.google.maps://");
        }
    }
    @IBAction func btnCallAction(_ sender: Any) {

        if let url = NSURL(string: "tel://\(self.arrService.mobile ?? "")"), UIApplication.shared.canOpenURL(url as URL) {
            
         UIApplication.shared.openURL(url as URL)
               }else
               {
                   showAlert(message: "Invalid number")
               }
        
        //UIApplication.shared.openURL(URL(string: "tel://" + (self.arrService.mobile ?? ""))! as URL)
    }
    @IBAction func btnEmailAction(_ sender: Any) {
        let email = arrService.email
        if let url = URL(string: "mailto:\(email ?? "")") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnSendEnquiryAction(_ sender: Any) {
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "EnquiryVC") as! EnquiryVC
        vc.InquiryID = self.arrService.id!
        vc.address = address
        vc.latitude = latitude
        vc.longitude = longitude
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TowingServiceCompanyVC {
    
    func setUI(){
        
        if arrService != nil {
            
            self.lbltitle.text = arrService.company_name!
            self.lblAboutValue.text = arrService.company_details!
            self.lblTiming.text = arrService.working_hours!
            self.lblDistance.text = arrService.distance! + " " + APP_LBL.distance_unit
            self.lblCompanyName.text = arrService.company_name!
            self.lblAddressValue.text = arrService.place?.address
            
            if let imgUrl = arrService.company_profile_image {
                
                imgLogo.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                    self.imgLogo.contentMode = .scaleAspectFill
                }
            } else {
                imgLogo.image = UIImage.init(named: APP_IMG.img_placeholder)
                imgLogo.contentMode = .scaleAspectFill
            }
        }
        
        lbltitle.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lbltitle.textColor = APP_COL.APP_Black_Color
        
        lblCompanyName.font = Utility.SetBold(Utility.Button_Font_size() + 2)
        lblCompanyName.textColor = APP_COL.APP_Black_Color
        
        lblTiming.font = Utility.SetRagular(Utility.Small_size_14())
        lblTiming.textColor = APP_COL.APP_LabelGrey
        
        lblDistance.font = Utility.SetRagular(Utility.Small_size_14())
        lblTiming.textColor = APP_COL.APP_LabelGrey
        
        lblAboutTitle.text = APP_LBL.about
        lblAboutTitle.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lblAboutTitle.textColor = APP_COL.APP_Black_Color
        
        lblAboutValue.font = Utility.SetRagular(Utility.Small_size_14())
        lblAboutValue.textColor = APP_COL.APP_Black_Color
        
        lblContactTitle.text = APP_LBL.contact
        lblContactTitle.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lblContactTitle.textColor = APP_COL.APP_Black_Color
        
        lblAddressValue.font = Utility.SetBlack(Utility.Small_size_14())
        lblAddressValue.textColor = APP_COL.APP_Black_Color
        
        btnGetDirection.setTitle(APP_LBL.get_direction, for: .normal)
        btnGetDirection.titleLabel?.font = Utility.SetSemiBold(Utility.Small_size_12())
        btnGetDirection.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        
        
        btnContactNumValue.setTitle(arrService.mobile, for: .normal)
        btnContactNumValue.titleLabel?.font = Utility.SetSemiBold(Utility.Small_size_14())
        btnContactNumValue.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        btnEmail.setTitle(arrService.email!, for: .normal)
        btnEmail.titleLabel?.font = Utility.SetSemiBold(Utility.Small_size_14())
        btnEmail.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        

        btnSendEnquiry.setTitle(APP_LBL.send_enquiry, for: .normal)
        btnSendEnquiry.titleLabel?.font = Utility.SetBlack(Utility.Header_Font_size() + 2)
        btnSendEnquiry.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnSendEnquiry.backgroundColor = APP_COL.APP_Color
        btnSendEnquiry.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btnSendEnquiry.layer.shadowOffset = CGSize.zero
        btnSendEnquiry.layer.shadowOpacity = 0.5
        btnSendEnquiry.layer.shadowRadius = 10.0
        btnSendEnquiry.layer.masksToBounds = false
        btnSendEnquiry.roundCorner(value: 4.0)
        
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        imgLogo.round()
    }
}
