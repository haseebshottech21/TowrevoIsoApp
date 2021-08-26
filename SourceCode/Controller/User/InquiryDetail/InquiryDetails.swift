//
//  InquiryDetails.swift
//  SourceCode
//
//  Created by Yesha on 19/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class InquiryDetails: BaseVC, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblservicetitle: UILabel!
    @IBOutlet weak var imglogo: UIImageView!
    
    @IBOutlet var scrollVW: UIScrollView!
    @IBOutlet weak var collectionhight: NSLayoutConstraint!
    @IBOutlet weak var imgCollectionview: UICollectionView!
    @IBOutlet weak var lblDetails: UILabel!
    var inquiryID = String()
    var arrInquiryDetails : CompanyDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDetail()
    }
    func SetUI()
    {
        lbltitle.text = arrInquiryDetails.company_name
        lbltitle.font = Utility.SetSemiBold(Utility.Small_size_14())
        lbltitle.textColor = APP_COL.APP_Black_Color
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        lblservicetitle.text = arrInquiryDetails.company_name
        lblemail.text = arrInquiryDetails.email
        lblmobile.text = arrInquiryDetails.mobile
        
        if let imgUrl = arrInquiryDetails.company_profile_image {
            
            imglogo.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                //self.imgLogo.contentMode = .scaleAspectFill
                self.imglogo.rounded()
            }
        } else {
            
            imglogo.image = UIImage.init(named: APP_IMG.img_placeholder)
            //imgLogo.contentMode = .scaleAspectFill
            self.imglogo.rounded()
        }
        
        
        lblservicetitle.font = Utility.SetSemiBold(Utility.Button_Font_size() + 2)
        lblservicetitle.textColor = APP_COL.APP_Black_Color
        
        lblemail.font = Utility.SetRagular(Utility.Small_size_14())
        lblemail.textColor = APP_COL.APP_LabelGrey
        
        lblmobile.font = Utility.SetRagular(Utility.Small_size_14())
        lblmobile.textColor = APP_COL.APP_LabelGrey
        
        lblDetails.font = Utility.SetRagular(Utility.Small_size_14())
        lblDetails.textColor = APP_COL.APP_LabelGrey
        lblDetails.text = arrInquiryDetails.description
        
        imgCollectionview.register(UINib(nibName: "InquiryImagesCell", bundle: nil), forCellWithReuseIdentifier: "InquiryImagesCell")
        //imgCollectionview.frame.width = imgCollectionview.frame.width / 3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/4-20, height: UIScreen.main.bounds.width/4-20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        imgCollectionview!.collectionViewLayout = layout
        
        imgCollectionview.delegate = self
        imgCollectionview.dataSource = self
        imgCollectionview.reloadData()
        collectionhight.constant = imgCollectionview.contentSize.height
        self.view.layoutIfNeeded()
        collectionhight.constant = imgCollectionview.contentSize.height
    }
    override func viewWillAppear(_ animated: Bool) {
       hideNavigationBar()
    }
    
  
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrInquiryDetails.image!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InquiryImagesCell", for: indexPath) as! InquiryImagesCell
        
        let images = arrInquiryDetails.image![indexPath.row]
        
        if let imgUrl = images.image {
            if let urlTemp = URL(string: imgUrl) {
                cell.img.sd_setImage(with: urlTemp, placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                    //cell.imglogo.contentMode = .scaleAspectFill
                    cell.img.layer.cornerRadius = 10
                }
            } else {
                cell.img.image = UIImage.init(named: APP_IMG.img_placeholder)
                cell.img.layer.cornerRadius = 10
            }
        } else {
            
            cell.img.image = UIImage.init(named: APP_IMG.img_placeholder)
            cell.img.layer.cornerRadius = 10
            //cell.imglogo.contentMode = .scaleAspectFill
        }
        
        return cell
    }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        SKPhotoBrowserOptions.displayAction = false
        var arrImages = [SKPhoto]()
        let images = arrInquiryDetails.image!
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
    func getDetail() {
        //towrevo.vrinsoft.in/api/CompanyList?user_id=51&category_id=1&latitude=23.018940&longitude=72.541512&token=e9ee988ca17cff4492456a6a8f708219&address=Ambawadi,Ahmedabad,Gujarat,India&page=1
        let par : [String : String] = [
            "user_id" : APP_DEL.currentUser!.user_id!,
            "token" : APP_DEL.currentUser!.token!,
            "id" : inquiryID,
            
        ]
        
        API.companydetails(param: par) { (notMod, mess) in
            
            if mess == nil && notMod != nil {
                self.arrInquiryDetails = notMod?.data!
                self.scrollVW.isHidden = false
                self.SetUI()
            } else {
                self.scrollVW.isHidden = true
                self.arrInquiryDetails = nil
                
                
                self.showAlert(message: mess ?? "")
            }
            
        }
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 100.0, height: 100.0)
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //
    //        let yourWidth = collectionView.bounds.width/3.0
    //        let yourHeight = yourWidth
    //
    //        return CGSize(width: yourWidth, height: yourHeight)
    //
    ////        if collectionView == self.imgCollectionview {
    ////
    ////            var collectionViewSize = imgCollectionview.frame.size
    ////            collectionViewSize.width = collectionViewSize.width / 3.0 //Display Three elements in a row.
    ////            return collectionViewSize
    ////        } else {
    ////            return CGSize(width: 60, height: 60)
    ////        }
    //    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets.zero
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    
}
