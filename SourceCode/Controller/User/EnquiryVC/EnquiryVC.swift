//
//  EnquiryVC.swift
//  SourceCode
//
//  Created by Yesha on 12/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit
import MobileCoreServices

class EnquiryVC: BaseVC, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
   
    @IBOutlet weak var fistnameview: UIView!
    @IBOutlet weak var lblfirstname: UILabel!
    @IBOutlet weak var txtfirstName: UITextField!
  
    @IBOutlet weak var lbllastname: UILabel!
    @IBOutlet weak var lastnameview: UIView!
    @IBOutlet weak var txtlastname: UITextField!
    
    
    @IBOutlet weak var lblcountrycode: UILabel!
    @IBOutlet weak var mobileview: UIView!
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var txtMobileNum: UITextField!
   
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    //@IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var messageview: UIView!
    @IBOutlet weak var lblmessage: UILabel!
    @IBOutlet weak var txtViewMsg: UITextView!
    
    @IBOutlet weak var lblAttachDoc: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewAttachDocument: UIView!
    
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var collectionHightConstraint: NSLayoutConstraint!
    
    var InquiryID = String()
    let AT = AttachmentHandler.shared
    var isValidated = true
    var arrImages : NSMutableArray = []
    var arrPhotos = NSMutableArray()
    
    var address = String()
    var latitude = String()
    var longitude = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtfirstName.delegate = self
        txtlastname.delegate = self
        txtEmail.delegate = self
        txtViewMsg.delegate = self
        txtMobileNum.delegate = self
        setUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAttachDoc(_ sender: Any) {
        
       
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if txtViewMsg.textColor == UIColor.lightGray {
//            txtViewMsg.text = nil
//            txtViewMsg.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Enter Message"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    @IBAction func btnProfileAction(_ sender: Any) {
       AT.showAttachmentActionSheet(type: [.camera, .phoneLibrary], vc: self)
              AT.imagePickedBlock = { (img) in
             //  self.imglogo.image = img
                let originalImage1 = Utility.compressImage(sourceImage: img)
                self.arrPhotos.add(originalImage1)
                
                self.SetUIAfterImageUpload()
       }
        APP_DEL.isImageAdded = false
    }
    @IBAction func btnCloseAction(_ sender: Any) {
        self.arrPhotos.removeObject(at: (sender as AnyObject).tag)
      self.SetUIAfterImageUpload()
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        
        guard let fname = txtfirstName.text, let lname = txtlastname.text, let mobileNum = txtMobileNum.text, let email = txtEmail.text, let message = txtViewMsg.text  else {
            return
        }
        
        if fname.isEmpty || fname.isReallyEmptyUE {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_first_name)
        }else if lname.isEmpty || lname.isReallyEmptyUE{
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_last_name)
        }else if (mobileNum.isEmpty) || mobileNum.isReallyEmptyUE {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_mobile_number)
        }else if !APP_FUNC.isValidContactNumber(number: mobileNum) {
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_mobile_number)
        } else if email.isEmpty || email.isReallyEmptyUE{
            
            isValidated = false
            showAlert(message: APP_LBL.please_enter_email)
            
        } else if !APP_FUNC.isValidEmail(email: email) {
            isValidated = false
            showAlert(message: APP_LBL.please_enter_valid_Email)
            
        } else if message.isEmpty || message.isReallyEmptyUE {
            isValidated = false
            showAlert(message: APP_LBL.please_enter_message)
            
        } else {
            
          //  http://towrevo.vrinsoft.in/api/register?first_name=additya&last_name=birla&email_address=additya%40gmail.com&mobile_number=%2B913332221618&password=123456&device_type=1
            isValidated = true
            self.showProgressHUD()
            
            let par : [String : String] = [
                "user_id" : APP_DEL.currentUser!.user_id!,
                "company_id" : InquiryID,
                "token" : APP_DEL.currentUser!.token!,
                "first_name" : self.txtfirstName.text!,
                "last_name" : self.txtlastname.text!,
                "email_address" : self.txtEmail.text!,
                "mobile_number" : self.txtMobileNum.text!,
                "about" : self.txtViewMsg.text!,
                "address" : address,
                "latitude" : latitude,
                "longitude" : longitude,
            ]
            API.userInquiry(param: par, arrImage: arrPhotos) { (response, mess) in
                if mess == nil {
                    self.showPopAlert(message: APP_LBL.inquiry_sent_successfully)
                } else {

                    self.showAlert(message: mess ?? "")
                }
                self.hideProgressHUD()
            }
        }
    }
    
    func goTONextScreen(){
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
           {
           return .default
       }
}

extension EnquiryVC {
    
    func setUI(){
        
        imagesCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        //imgCollectionview.frame.width = imgCollectionview.frame.width / 3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/4-20, height: UIScreen.main.bounds.width/4-20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        imagesCollection!.collectionViewLayout = layout
        
        viewAttachDocument.roundCorner(value: 10.0)
        viewAttachDocument.layer.borderColor = (APP_COL.APP_Color).cgColor
        viewAttachDocument.layer.borderWidth = 0.5
        
        lblTitle.text = APP_LBL.inquiry_title
        lblTitle.font = Utility.SetSemiBold(Utility.Small_size_14())
        lblTitle.textColor = APP_COL.APP_Black_Color
        
//        lblMessage.text = APP_LBL.message
//        lblMessage.font = Utility.SetRagular(Utility.Header_Font_size() + 2)
//        lblMessage.textColor = APP_COL.APP_Black_Color
        
        lblfirstname.text = APP_LBL.first_name
        lblfirstname.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblfirstname.textColor = APP_COL.APP_Black_Color
        
        txtfirstName.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtfirstName.textColor = APP_COL.APP_DarkGrey_Color
        
        fistnameview.backgroundColor = APP_COL.txtBGcolor
        fistnameview.roundView()
        
        lbllastname.text = APP_LBL.last_name
        lbllastname.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lbllastname.textColor = APP_COL.APP_Black_Color
        
        txtlastname.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtlastname.textColor = APP_COL.APP_DarkGrey_Color
        
        lastnameview.backgroundColor = APP_COL.txtBGcolor
        lastnameview.roundView()
        
        lblemail.text = APP_LBL.email_address
        lblemail.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblemail.textColor = APP_COL.APP_Black_Color
        
        txtEmail.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtEmail.textColor = APP_COL.APP_DarkGrey_Color
        
        emailview.backgroundColor = APP_COL.txtBGcolor
        emailview.roundView()
        
       if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                   print(countryCode)
        //           let strCode = Countries.countryFromCountryCode(countryCode: countryCode)
        //           btnPhoneCode.setTitle("+\(strCode.phoneExtension)", for: .normal)
                lblcountrycode.text = String(format: "+ %@", APP_FUNC.GetCountryCallingCode(countryRegionCode: countryCode)!)
               }
        lblcountrycode.font = Utility.SetSemiBold(Utility.Small_size_12() + 2)
        lblcountrycode.textColor = APP_COL.APP_Color
        
        lblmobile.text = APP_LBL.mobile_number_colon
        lblmobile.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblmobile.textColor = APP_COL.APP_Black_Color
        
        txtMobileNum.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtMobileNum.textColor = APP_COL.APP_DarkGrey_Color
        
        mobileview.backgroundColor = APP_COL.txtBGcolor
        mobileview.roundView()
        
        lblmessage.text = APP_LBL.about_colon
        lblmessage.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        lblmessage.textColor = APP_COL.APP_Black_Color
        
        txtViewMsg.font = Utility.SetRagular(Utility.Small_size_12() + 2)
        txtViewMsg.textColor = APP_COL.APP_DarkGrey_Color
        
        messageview.backgroundColor = APP_COL.txtBGcolor
        messageview.roundView()
        
        lblAttachDoc.text = APP_LBL.attach_image
        lblAttachDoc.font = Utility.SetRagular(Utility.Small_size_14())
        lblAttachDoc.textColor = APP_COL.APP_Color
        
        btnSave.setTitle(APP_LBL.save, for: .normal)
        btnSave.titleLabel?.font = Utility.SetRagular(Utility.Small_size_14() + 2)
        btnSave.setTitleColor(APP_COL.APP_White_Color, for: .normal)
        btnSave.backgroundColor = APP_COL.APP_Color
        btnSave.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
        btnSave.layer.shadowOffset = CGSize.zero
        btnSave.layer.shadowOpacity = 0.5
        btnSave.layer.shadowRadius = 10.0
        btnSave.layer.masksToBounds = false
        btnSave.roundCorner(value: 4.0)
        
        
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

        
        txtEmail.text =  APP_DEL.currentUser!.email!
        txtfirstName.text =  APP_DEL.currentUser!.first_name!
        txtlastname.text =  APP_DEL.currentUser!.last_name!
        txtMobileNum.text =  APP_DEL.currentUser!.mobile!
    }
    
    func SetUIAfterImageUpload()
{
    imagesCollection.delegate = self
    imagesCollection.dataSource = self
    imagesCollection.reloadData()
    collectionHightConstraint.constant = imagesCollection.contentSize.height
    self.view.layoutIfNeeded()
    collectionHightConstraint.constant = imagesCollection.contentSize.height
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//            if (textField == txtMobileNum) {
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
//            return true
//        }
}



extension EnquiryVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return arrPhotos.count
       }
          
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.btnClose.isHidden = false
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(btnCloseAction(_:)), for: .touchUpInside)
        cell.image.image = arrPhotos[indexPath.row] as? UIImage
        cell.image.contentMode = .scaleAspectFill
           return cell
       }
}
extension String {
    var isReallyEmptyUE : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
