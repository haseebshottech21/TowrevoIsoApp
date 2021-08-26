//
//  MenuPopupVC.swift
//  SocialBug
//
//  Created by vishal.n on 16/06/20.
//  Copyright © 2020 Yesha. All rights reserved.
//

import UIKit

protocol DidSelectMenu {
    
    func didSelectMenu(index: String)
}

class MenuPopupVC: UIViewController {

    
    @IBOutlet weak var tblView: UITableView!
    
    var arrMenu : [String] = []
    
    var deleagteDidSelectMenu: DidSelectMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = UITableView.automaticDimension
        self.tblView.register(UINib(nibName: "MenuPopupCell", bundle: nil), forCellReuseIdentifier: "MenuPopupCell")
        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.tblView.reloadData()
     
        tblView.layoutIfNeeded()
        preferredContentSize = CGSize(width: 180, height: tblView.contentSize.height + 22.0)
    }
    
    
}

extension MenuPopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "MenuPopupCell") as! MenuPopupCell
        cell.selectionStyle = .none

        cell.lblTitle.text = arrMenu[indexPath.row]
       
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: false)
        self.deleagteDidSelectMenu?.didSelectMenu(index: arrMenu[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
