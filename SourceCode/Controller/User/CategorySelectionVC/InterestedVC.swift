//
//  MatchVC.swift
//  Vepye
//
//  Created by pratima on 10/09/20.
//  Copyright © 2020 Pratima. All rights reserved.
//

import UIKit

protocol interestedDelegate {
    func SelectedIntrestedID(arrID : NSMutableArray , strID : String , arrIntrested : [category])
}

class InterestedVC: BaseVC {
    
    //MARK:-@IBOutlet & Veriable

    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblInterested: UITableView!
    var arrInterested: [category] = []
    var arrId = NSMutableArray()
    var delegate : interestedDelegate!
    var strID = String()
    var selectedArr : [category] = []

    @IBOutlet var btnDone: UIButton!
    
   //MARK:-Life cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setRefreshController(scrollView: self.tblInterested)
        setUI()
    }
    func setUI()
    {
        lblTitle.text = APP_LBL.select_category
        lblTitle.font = Utility.SetSemiBold(Utility.Header_Font_size())
        lblTitle.textColor = APP_COL.APP_Black_Color
        btnDone.setTitle(APP_LBL.done, for: .normal)
               btnDone.titleLabel?.font = Utility.SetBlack(Utility.Header_Font_size() + 2)
               btnDone.setTitleColor(APP_COL.APP_White_Color, for: .normal)
               btnDone.backgroundColor = APP_COL.APP_Color
                btnDone.layer.shadowColor = (APP_COL.APP_Grey_Color).cgColor
                           btnDone.layer.shadowOffset = CGSize.zero
                           btnDone.layer.shadowOpacity = 0.5
                           btnDone.layer.shadowRadius = 10.0
                           btnDone.layer.masksToBounds = false
                           btnDone.roundCorner(value: 4.0)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
       
            return .default
          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCategoryList()
        self.setLabelandFont()
        self.hideNavigationBar()
        
    }
  
    override func refreshCalled(res: Bool) {
     self.refreshView.endRefreshing()
    }
    func getCategoryList() {
        //towrevo.vrinsoft.in/api/towCategory?user_id=40&token=16a50d6c3580363c1aefaad06d834232&user_type=2
        
        let par : [String : String] = [
            "user_id" : "",
            "user_type" : "2",
            "token" : "",
        ]
        
        self.showProgressHUD()
        API.towCategory(param: par) { (notMod, mess) in
            
            if mess == nil && notMod != nil {
                self.arrInterested = notMod?.data! ?? []
                            for i in 0..<self.arrInterested.count{
                                let id = self.arrInterested[i].category_id ?? ""
                                if self.arrId.contains(id){
                                    self.selectedArr.append(self.arrInterested[i])
                                }
                            }
                            
                            if self.arrInterested.count  == 0 {
                                self.setNoData(scrollView: self.tblInterested)
                            } else {
                                self.tblInterested.delegate = self
                                self.tblInterested.dataSource = self
                            }
                            self.tblInterested.reloadData()
                } else {
                self.arrInterested = []
                
                if notMod?.code != 0 {
                }
            }
            self.hideProgressHUD()
        }
    }
    
 
 //MARK:- Action Btn Menu
 @IBAction func actionBtnBack(_ sender: UIButton){
     self.navigationController?.popViewController(animated: true)
 }
    @IBAction func btnDoneAction(_ sender: Any) {
       if arrId.count > 0 {
           strID = arrId.componentsJoined(by: ",")
       }else{
           strID = ""
        showAlert(message: APP_LBL.please_select_category)
       }
       
       delegate.SelectedIntrestedID(arrID: arrId, strID: strID, arrIntrested: selectedArr)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-Set label and font
    func  setLabelandFont(){
        self.tblInterested.register(UINib(nibName: "InterestedCell", bundle: nil), forCellReuseIdentifier: "InterestedCell")
    }
}

//MARK:-
extension InterestedVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrInterested.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.tblInterested.dequeueReusableCell(withIdentifier: "InterestedCell") as! InterestedCell
               cell.selectionStyle = .none
       cell.selectionStyle = .none
        let dictData = arrInterested[indexPath.row]
        cell.lblName.text = dictData.category_name
        
        let id = dictData.category_id ?? ""
        if arrId.contains(id) {
            cell.lblName.textColor = UIColor.black
            cell.imgCell.image = UIImage(named:"icon_check")
        }else{
            cell.lblName.textColor = UIColor.black
            cell.imgCell.image = UIImage(named:"icon_check_light")
        }
        cell.lblName.setFont(font: .Regular, size: 14)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = arrInterested[indexPath.row].category_id
        if arrId.contains(id!) {
            arrId.remove(id!)
            
        }else{
            arrId.add(id!)
            
        }
        self.selectedArr.removeAll()
        for i in 0..<self.arrInterested.count{
            let id = self.arrInterested[i].category_id ?? ""
            if self.arrId.contains(id){
                self.selectedArr.append(self.arrInterested[i])
            }
        }
        tblInterested.reloadData()
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
      }
    
    @IBAction func btnUnblockAction(_ sender: UIButton){
        arrInterested.remove(at: sender.tag)
        if arrInterested.count == 0 {
            self.setNoData(scrollView: self.tblInterested)
            self.tblInterested.reloadData()
        }
    }
    
}
