//
//  CompanyInquirydetailVC.swift
//  SourceCode
//
//  Created by Yesha on 05/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class CompanyInquirydetailVC: BaseVC, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    

    @IBOutlet var scrollVW: UIScrollView!
    
    @IBOutlet var vwImage: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lbltital: UILabel!
    
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    
    @IBOutlet weak var lblabout: UILabel!
    @IBOutlet weak var lblabouttxt: UILabel!
    
    @IBOutlet weak var lblimages: UILabel!
    
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var collectionHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblcontact: UILabel!
    @IBOutlet weak var imglocation: UIImageView!
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var btngetdirection: UIButton!
    @IBOutlet weak var imgcall: UIImageView!
    @IBOutlet weak var btncall: UIButton!
    
    @IBOutlet weak var imgemail: UIImageView!
    @IBOutlet weak var btnemail: UIButton!
    
   var inquiryID = String()
    var arrCustomerDetail : CustomerDetail!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDetail()
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCustomerDetail.image!.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let images = arrCustomerDetail.image![indexPath.row]
        
        if let imgUrl = images.image {
            if let urlTemp = URL(string: imgUrl) {
                cell.image.sd_setImage(with: urlTemp, placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                    cell.image.contentMode = .scaleAspectFill
                    cell.image.layer.cornerRadius = 10.0
                }
            } else {
               cell.image.image = UIImage.init(named: APP_IMG.img_placeholder)
                cell.image.layer.cornerRadius = 10.0
           }
        } else {

            cell.image.image = UIImage.init(named: APP_IMG.img_placeholder)
            cell.image.layer.cornerRadius = 10.0
            cell.image.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        SKPhotoBrowserOptions.displayAction = false
        var arrImages = [SKPhoto]()
        let images = arrCustomerDetail.image!
        for i in 0..<images.count{
            let photo = SKPhoto.photoWithImageURL(images[i].image!)
            photo.shouldCachePhotoURLImage = true
            arrImages.append(photo)
        }
        
        
        let browser = SKPhotoBrowser(photos: arrImages)
        browser.currentPageIndex = indexPath.row
        browser.modalPresentationStyle = .fullScreen
        browser.modalTransitionStyle = .crossDissolve
        self.present(browser, animated: true, completion: {})
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100.0, height: 100.0)
//    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGetDirection(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(arrCustomerDetail.place?.latitude! ?? ""),\(arrCustomerDetail.place?.longitude! ?? "")&directionsmode=driving")! as URL)
        } else
        {
            UIApplication.shared.openURL(NSURL(string:
            "https://apps.apple.com/us/app/google-maps-transit-food/id585027354")! as URL)
            NSLog("Can't use com.google.maps://");
        }
    }
    
    @IBAction func btnCallAction(_ sender: Any) {
        
        if let url = NSURL(string: "tel://\(arrCustomerDetail!.mobile!)"), UIApplication.shared.canOpenURL(url as URL) {
           
        UIApplication.shared.openURL(url as URL)
              } else
        {
            showAlert(message: "Invalid number")
        }
        
    }
    @IBAction func btnEmailAction(_ sender: Any) {
        let email = arrCustomerDetail!.email!
        if let url = URL(string: "mailto:\(email ?? "")") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension CompanyInquirydetailVC {
    
    func setUI() {
        
        lbltital.text = APP_LBL.Customer_Details
        lbltital.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lbltital.textColor = APP_COL.APP_Black_Color
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        if let imgUrl = arrCustomerDetail.profile_image {
            
            imgprofile.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                //self.imgLogo.contentMode = .scaleAspectFill
                self.imgprofile.rounded()
            }
        } else {
            
            imgprofile.image = UIImage.init(named: APP_IMG.img_placeholder)
            //imgLogo.contentMode = .scaleAspectFill
            self.imgprofile.rounded()
        }
        
        lblname.text = arrCustomerDetail.user_name
        lblname.font = Utility.SetSemiBold(Utility.Button_Font_size() + 2)
        lblname.textColor = APP_COL.APP_Black_Color
        
       // lbldate.text = (DT.getDateFromStringWith(strDate: arrCustomerDetail.date ?? "", currentFormate: APP_CONST.apiDateFormate_ymdhms, newFormate: APP_CONST.appDateFormateWithoutTime)).strDate
        lbldate.text = arrCustomerDetail.date
        lbldate.font = Utility.SetRagular(Utility.Small_size_12())
        lbldate.textColor = APP_COL.APP_LabelGrey
        
        lblabout.text = APP_LBL.about
        lblabout.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lblabout.textColor = APP_COL.APP_Black_Color
        
        lblabouttxt.text = arrCustomerDetail.about
        lblabouttxt.font = Utility.SetRagular(Utility.Small_size_14())
        lblabouttxt.textColor = APP_COL.APP_DarkGrey_Color
        
        lblimages.text = APP_LBL.images
        lblimages.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lblimages.textColor = APP_COL.APP_Black_Color
        
        lblcontact.text = APP_LBL.contact
        lblcontact.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lblcontact.textColor = APP_COL.APP_Black_Color
        
        lbllocation.text = arrCustomerDetail.place?.address
        lbllocation.font = Utility.SetBlack(Utility.Small_size_14())
        lbllocation.textColor = APP_COL.APP_Black_Color
        
        btngetdirection.setTitle(APP_LBL.get_direction, for: .normal)
        btngetdirection.titleLabel?.font = Utility.SetSemiBold(Utility.Small_size_12())
        btngetdirection.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        btncall.setTitle(arrCustomerDetail.mobile, for: .normal)
        btncall.titleLabel?.font = Utility.SetBlack(Utility.Small_size_14())
        btncall.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        btnemail.setTitle(arrCustomerDetail.email, for: .normal)
        btnemail.titleLabel?.font = Utility.SetBlack(Utility.Small_size_14())
        btnemail.setTitleColor(APP_COL.APP_Color, for: .normal)
        
        if  arrCustomerDetail.image!.count > 0
        {
            vwImage.isHidden = false
            imagesCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
            //imgCollectionview.frame.width = imgCollectionview.frame.width / 3
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width/4-20, height: UIScreen.main.bounds.width/4-20)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
            imagesCollection!.collectionViewLayout = layout
            
            imagesCollection.delegate = self
            imagesCollection.dataSource = self
            imagesCollection.reloadData()
            collectionHightConstraint.constant = imagesCollection.contentSize.height
            self.view.layoutIfNeeded()
            collectionHightConstraint.constant = imagesCollection.contentSize.height
        } else
        {
            vwImage.isHidden = true
        }
        
    }
    func getDetail() {
        //towrevo.vrinsoft.in/api/CompanyList?user_id=51&category_id=1&latitude=23.018940&longitude=72.541512&token=e9ee988ca17cff4492456a6a8f708219&address=Ambawadi,Ahmedabad,Gujarat,India&page=1
        let par : [String : String] = [
            "user_id" : APP_DEL.currentUser!.user_id!,
            "token" : APP_DEL.currentUser!.token!,
            "id" : inquiryID,
        ]
        
        API.customerdetails(param: par) { (notMod, mess) in
            if mess == nil && notMod != nil {
                self.arrCustomerDetail = notMod?.data!
                self.scrollVW.isHidden = false
                self.setUI()
            } else {
                self.scrollVW.isHidden = true
                self.arrCustomerDetail = nil
                self.showAlert(message: mess ?? "")
            }
            
        }
    }
}
