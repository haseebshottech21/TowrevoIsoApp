//
//  FaqVC.swift
//  Tappoo
//
//  Created by vishal.n on 05/02/20.
//  Copyright © 2020 Yesha. All rights reserved.
//

import UIKit


class FaqVC: BaseVC {

    @IBOutlet var tblFaq: UITableView!
    
    @IBOutlet weak var lblFaq: UILabel!
    
    @IBOutlet weak var btnback: UIButton!
    //var objFaq: FAQModel?
    var arrFaq : [FAQModel] = []

    //var isRefresh = Bool()
    var strExpandIndex = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.faqsAPI(isLoader: true)
        //self.setRefreshController(scrollView: tblFaq)
        
        //self.navigationController?.navigationBar.isHidden = true
        //self.tabBarController?.tabBar.isHidden = true

        //lblFaq.text = "FAQs"

        
        
        
        //faqsAPI(isLoader: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      hideNavigationBar()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    func faqsAPI(isLoader : Bool){
//towrevo.vrinsoft.in/api/faq?user_type=3
        if (isLoader) {

            self.showLoader()
        }

        let param : [String : String] = [
            "user_type" : APP_DEL.currentUser!.user_type!,
        ]


        API.faq(param: param) { (responseData, resString) in

            if (responseData == nil) {

                self.showAlert(message: resString ?? APP_LBL.something_went_wrong)

            } else {
                self.arrFaq = responseData?.data![0] ?? []
                for i in 0..<self.arrFaq.count{
                    self.arrFaq[i].isExpanded = "0"
                    
                }
                self.setUI()
            }

            self.hideLoader()
        }

    }
    override var preferredStatusBarStyle: UIStatusBarStyle
        {
        return .default
    }
}

extension FaqVC {
    
    func setUI() {
        
        lblFaq.text = APP_LBL.faq
        lblFaq.font = Utility.SetSemiBold(Utility.Small_size_14())
        lblFaq.textColor = APP_COL.APP_Black_Color
        //lblFaq.font = Utility.SetSemiBold(Utility.Header_Font_size())
        btnback.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        let nib = UINib(nibName: "FaqTblCell", bundle: nil)
        tblFaq.register(nib, forCellReuseIdentifier: "FaqTblCell")
        tblFaq.tableFooterView = UIView()
        
        
        tblFaq.delegate = self
        tblFaq.dataSource = self
        tblFaq.reloadData()
    }
}


extension FaqVC : UITableViewDelegate , UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFaq.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTblCell", for: indexPath) as! FaqTblCell
    
        let dictdata = arrFaq[indexPath.row]
        let strSelected = dictdata.isExpanded
        
//        stringEncode(str: dictdata.question!, lbl: cell.lblAns)
        cell.lblAns.text = dictdata.answer ?? ""
        cell.lblQue.text = dictdata.question ?? ""
//        cell.lblAns.text = dictdata.faq_content
//        cell.lblCount.text = String(format: "%@.",String(indexPath.row + 1))
        if strSelected == "0"{
            cell.imgArrow.image = UIImage(named: "leftarrow")
            cell.lblAns.isHidden = true
            cell.lblLine.isHidden = true
            cell.lblQue.font = Utility.SetRagular(Utility.TextField_Font_size())

            
        }else{
            
            cell.imgArrow.image = UIImage(named: "bottomarrow")
            cell.lblAns.isHidden = false
            cell.lblLine.isHidden = false
            cell.lblQue.font = Utility.SetSemiBold(Utility.TextField_Font_size())

            
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0..<arrFaq.count{
            arrFaq[i].isExpanded = "0"
        }
        
        if String(indexPath.row) == strExpandIndex{
            strExpandIndex = ""
        }else{
            arrFaq[indexPath.row].isExpanded = "1"
            strExpandIndex = String(indexPath.row)
        }
        tblFaq.reloadData()
        
    }
    //MARK:- style html with html
    
//    func styledHTMLwithHTML(_ HTML: String) -> String {
//
//        let style: String = "<meta charset=\"UTF-8\"><style> body { font-family: '\(FontName.Regular.rawValue)'; font-size: \(Utility.TextField_Font_size())px; }</style>"
//
//        return "\(style)\(HTML)"
//    }
//
//    func stringEncode(str : String , lbl : UILabel){
//
//
//        let strHtmlString = str
//        let attributedstringdata = try! NSAttributedString(data: (strHtmlString.data(using: String.Encoding.utf8))!, options: [NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentReadingOptionKey.documentType.rawValue): NSAttributedString.DocumentType.html] , documentAttributes: nil)
//
//        lbl.text = attributedstringdata.string
//
//        let strhtml2 =  lbl.text
//
//        let attributedstringdata1 = try! NSAttributedString(data: (strhtml2!.data(using: String.Encoding.utf8))!, options: [NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentReadingOptionKey.documentType.rawValue): NSAttributedString.DocumentType.html] , documentAttributes: nil)
//
//        lbl.text = attributedstringdata1.string
//    }
//
    
    
}

