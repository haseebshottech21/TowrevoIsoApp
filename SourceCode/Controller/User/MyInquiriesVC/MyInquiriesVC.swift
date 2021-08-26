//
//  MyInquiriesVC.swift
//  SourceCode
//
//  Created by Yesha on 18/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class MyInquiriesVC: BaseVC, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblTital: UILabel!
    @IBOutlet weak var tblmyinquiries: UITableView!
    
    var arrmyinquiry : [InquiryList] = []
    var myinquiryMod : InquiryListModel?
    var page_no : Int = 1
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRefreshController(scrollView: self.tblmyinquiries)
        self.getCompantList(isClear: true, isProgress: true)
        tblmyinquiries.register(UINib(nibName: "MyInquiryCell", bundle: nil), forCellReuseIdentifier: "MyInquiryCell")
        

         self.tblmyinquiries.tableFooterView = UIView(frame: .zero)
    
        lblTital.text = APP_LBL.my_inquiries
        lblTital.font = Utility.SetSemiBold(Utility.Small_size_14())
        lblTital.textColor = APP_COL.APP_Black_Color
        
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
    override func viewWillAppear(_ animated: Bool) {
       hideNavigationBar()
    }
    
    @IBAction func btnbackaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
       @objc func refreshList(noti: Notification) {
                   
                   self.refreshCalled(res: true)
               }
            override func refreshCalled(res: Bool) {
                
                self.getCompantList(isClear: true, isProgress: false)
            }
               func checkNoData() {
                   
                   if self.arrmyinquiry.count  == 0 {
                       self.setNoData(scrollView: self.tblmyinquiries)
                   } else {
                       self.tblmyinquiries.delegate = self
                       self.tblmyinquiries.dataSource = self
                   }
                   
                   self.tblmyinquiries.reloadData()
                   self.refreshView.endRefreshing()
               }
               func checkPagination() {
                   
                if Int(self.myinquiryMod?.page ?? "0")! > self.arrmyinquiry.count {
    
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
    //towrevo.vrinsoft.in/api/customerInquirylist?user_id=61&token=fqIctuDOsFMjCHjBVf9Z02TwtYGbnJ9KtZiMRQdHzriGyPKpMN57qEJlnB2BfpIUKbynQFtq4Puyfphr&page=1
                 let par : [String : String] = [
                     "user_id" : APP_DEL.currentUser!.user_id!,
                     "token" : APP_DEL.currentUser!.token!,
                     "page" : "\(self.page_no)"
                 ]
                 

                 API.customerInquirylist(param: par) { (notMod, mess) in
                                 
                     if isProgress {
                         self.hideProgressHUD()
                     }
                     
                     if mess == nil && notMod != nil {
                                 
                         if isClear {
                             
                             self.myinquiryMod = nil
                             self.arrmyinquiry = []
                         }
                         
                         self.myinquiryMod = notMod
                         
                         if self.arrmyinquiry.count == 0 {
                             self.arrmyinquiry = notMod?.data! ?? []
                         } else {
                             self.arrmyinquiry.append(contentsOf: (notMod?.data! ?? []) as [InquiryList])
                         }
                         
                     } else {
                         
                         if isProgress {
                             self.hideProgressHUD()
                         }
                         self.myinquiryMod = nil
                         self.arrmyinquiry = []

                         if notMod?.code != 0 {
                             if isProgress {
                                if notMod?.code != 0 && notMod?.code != -7
                                {
                                 self.showAlert(message: mess ?? "")
                                }
                             }
                         }
                     }
                     self.checkNoData()
                    self.tblmyinquiries.reloadData()
                 }
             }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrmyinquiry.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyInquiryCell", for: indexPath) as! MyInquiryCell
        
        cell.selectionStyle = .none
        if indexPath.row == (self.arrmyinquiry.count - 3) {
            
            self.checkPagination()
        }
            let inquiriesdata = arrmyinquiry[indexPath.row]
            print(inquiriesdata)
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width + 10, bottom: 0, right: UIScreen.main.bounds.width + 10)
            
            cell.lbltitle.font = Utility.SetSemiBold(Utility.Button_Font_size() + 2)
            cell.lbltitle.textColor = APP_COL.APP_Black_Color
            
            cell.lbldate.font = Utility.SetRagular(Utility.Small_size_14())
            cell.lbldate.textColor = APP_COL.APP_LabelGrey
            
        cell.lbltitle?.text = inquiriesdata.company_name
         //   cell.lbldate?.text = (DT.getDateFromStringWith(strDate: inquiriesdata.date ?? "", currentFormate: APP_CONST.apiDateFormate_ymdhms, newFormate: APP_CONST.appDateFormateWithoutTime)).strDate
            cell.lbldate?.text = inquiriesdata.date ?? ""
            //cell.tag = indexPath.row
        
        
        if let imgUrl = inquiriesdata.profile_image {

            cell.imglogo.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                //cell.imglogo.contentMode = .scaleAspectFill
                cell.imglogo.layer.cornerRadius = cell.imglogo.frame.height / 2
            }
        } else {

            cell.imglogo.image = UIImage.init(named: APP_IMG.img_placeholder)
            cell.imglogo.layer.cornerRadius = cell.imglogo.frame.height / 2
            //cell.imglogo.contentMode = .scaleAspectFill
        }
            return cell
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyInquiryCell", for: indexPath) as! MyInquiryCell
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InquiryDetails") as! InquiryDetails
        vc.inquiryID = arrmyinquiry[indexPath.row].id!
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
}
