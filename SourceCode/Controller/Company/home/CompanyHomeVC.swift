//
//  CompanyHomeVC.swift
//  SourceCode
//
//  Created by Yesha on 04/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import UIKit

class CompanyHomeVC: BaseVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var toolbarview: UIView!
    @IBOutlet weak var btnmenu: UIButton!
    //@IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lbltital: UILabel!
    
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var tblInquiery: UITableView!
    
   var arrmyinquiry : [CompanyInquiryList] = []
    var myinquiryMod : CompanyInquiryListModel?
    var page_no : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRefreshController(scrollView: self.tblInquiery)
        self.getInquiryList(isClear: true, isProgress: true)
        // Do any additional setup after loading the view.
        
        lbltital.text = APP_LBL.inquiry_management
        lbltital.font = Utility.SetSemiBold(Utility.Small_size_14() + 2)
        lbltital.textColor = APP_COL.APP_White_Color
        
        btnmenu.imageEdgeInsets = UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3)
        
        mainview.backgroundColor = APP_COL.APP_Color
        toolbarview.backgroundColor = APP_COL.APP_Color
        
        tblInquiery.register(UINib(nibName: "CompanyInquierycell", bundle: nil), forCellReuseIdentifier: "CompanyInquierycell")
        tblInquiery.delegate = self
        tblInquiery.dataSource = self
        tblInquiery.reloadData()
        

        self.tblInquiery.tableFooterView = UIView(frame: .zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }

    @IBAction func btnMenuAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        vc.modalPresentationStyle = .overFullScreen
        vc.parentVc = self
        self.present(vc, animated: false, completion: nil)
    }
    @objc func refreshList(noti: Notification) {
                   
                   self.refreshCalled(res: true)
               }
            override func refreshCalled(res: Bool) {
                
                self.getInquiryList(isClear: true, isProgress: false)
            }
               func checkNoData() {
                   
                   if self.arrmyinquiry.count  == 0 {
                       self.setNoData(scrollView: self.tblInquiery)
                   } else {
                       self.tblInquiery.delegate = self
                       self.tblInquiery.dataSource = self
                   }
                   
                   self.tblInquiery.reloadData()
                   self.refreshView.endRefreshing()
               }
               func checkPagination() {
                   
                if Int(self.myinquiryMod?.total_count ?? 0) > self.arrmyinquiry.count {
    
                       print("GET MORE PAGE")
                       self.page_no = self.page_no + 1
                       self.getInquiryList(isClear: false, isProgress: true)
                   } else {
                       print("NO MORE PAGE")
                   }
               }
    func getInquiryList(isClear: Bool, isProgress: Bool) {
                 
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
                 

                 API.companyInquirylist(param: par) { (notMod, mess) in
                                 
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
                             self.arrmyinquiry.append(contentsOf: (notMod?.data! ?? []) as [CompanyInquiryList])
                         }
                         
                     } else {
                         
                         if isProgress {
                             self.hideProgressHUD()
                         }
                         self.myinquiryMod = nil
                         self.arrmyinquiry = []

                        if notMod?.code != 0 && notMod?.code != -7{
                             if isProgress {
                                 self.showAlert(message: mess ?? "")
                             }
                         }
                     }
                     self.checkNoData()
                    self.tblInquiery.reloadData()
                 }
             }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrmyinquiry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyInquierycell", for: indexPath) as! CompanyInquierycell

        cell.selectionStyle = .none
        if indexPath.row == (self.arrmyinquiry.count - 3) {
            
            self.checkPagination()
        }
        let arratyItem = arrmyinquiry[indexPath.row]
        
        if let imgUrl = arratyItem.profile_image {

            cell.imgprofile.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:APP_IMG.img_placeholder), options: .refreshCached) { (img, err, _, _) in
                //cell.imglogo.contentMode = .scaleAspectFill
                cell.imgprofile.layer.cornerRadius = cell.imgprofile.frame.height / 2
               
            }
        } else {

            cell.imgprofile.image = UIImage.init(named: APP_IMG.img_placeholder)
            cell.imgprofile.layer.cornerRadius = cell.imgprofile.frame.height / 2
            //cell.imglogo.contentMode = .scaleAspectFill
        }
        cell.imgprofile.layer.masksToBounds = true
        cell.lbltitle.text = arratyItem.user_name
        cell.lbltitle.font = Utility.SetSemiBold(Utility.Button_Font_size() + 2)
        cell.lbltitle.textColor = APP_COL.APP_Black_Color
        
        cell.lblmobile.text = arratyItem.mobile
        cell.lblmobile.font = Utility.SetRagular(Utility.Small_size_14())
        cell.lblmobile.textColor = APP_COL.APP_Color
        
       // cell.lbldate.text = (DT.getDateFromStringWith(strDate: arratyItem.date ?? "", currentFormate: APP_CONST.apiDateFormate_ymdhms, newFormate: APP_CONST.appDateFormateWithoutTime)).strDate
        cell.lbldate.font = Utility.SetRagular(Utility.Small_size_12())
        cell.lbldate.textColor = APP_COL.APP_LabelGrey
        
        cell.lbldate?.text = arratyItem.date ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyInquirydetailVC") as! CompanyInquirydetailVC
        vc.inquiryID = self.arrmyinquiry[indexPath.row].id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
