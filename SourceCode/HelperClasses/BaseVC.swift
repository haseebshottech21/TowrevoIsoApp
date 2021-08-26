//
//  BaseVC.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import LGRefreshView
import IQKeyboardManagerSwift
import NVActivityIndicatorView

class BaseVC: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {

    var isDismissOnTap: Bool = true
    var activityIndicatorView : NVActivityIndicatorView?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupHideKeyboardOnTap()
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width/2) - 25.0, y: (UIScreen.main.bounds.height/2) - 25.0, width: 50.0, height: 50.0), type: .ballPulse, color: APP_COLOR, padding: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) ?? false {
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        }
//    }
//    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//          
//        return ((self.navigationController?.viewControllers.count ?? 1) > 1)
//      }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
       
            return .lightContent
        
    }
    
    
    func showLoader(message: String? = nil) {
//        let controller = Utility.getVisibleViewController(APP_DEL.window?.rootViewController)
        self.view.addSubview(self.activityIndicatorView!)
        self.view.isUserInteractionEnabled = false
        self.activityIndicatorView?.startAnimating()
    }
    
    func hideLoader(message: String? = nil) {
        self.activityIndicatorView?.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.activityIndicatorView!.removeFromSuperview()
    }
    
    var isForceModel: Bool = false
    func setNavigationBar(title: String?, setBackArrow: Bool, isForceModel: Bool = false, isWhiteTheme: Bool = false, isDismissOnTap: Bool = true)
    {
        self.isForceModel = isForceModel
        if !isModal() || isForceModel
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.view.backgroundColor = isWhiteTheme ? APP_COL.White : APP_COL.NavBG
            self.navigationItem.title = title
            self.navigationController?.navigationBar.barStyle = UIBarStyle.init(rawValue: 1)!
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = isWhiteTheme ? APP_COL.White : APP_COL.NavBG
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: isWhiteTheme ? APP_COL.Black : APP_COL.White,.font: UIFont(name: FontName.SemiBold.rawValue, size: CGFloat(19.0))!]
            
            
            if setBackArrow
            {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: isWhiteTheme ? APP_IMG.back_white_arrow : APP_IMG.back_black_arrow, style: .plain, target: self, action: #selector(self.btnBaseBackTapped(item:)))
                self.navigationItem.leftBarButtonItem?.tintColor = isWhiteTheme ? APP_COL.Black : APP_COL.White
                
                
//                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            }
        }
        
        if isDismissOnTap {
            setupHideKeyboardOnTap()
        }
    }
    let navTitleFont = UIFont(name: FontName.SemiBold.rawValue, size: CGFloat(19.0))!
    
    func hideNavigationBar() {
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func showNavigationBar()
    {
        if let nav = self.navigationController
        {
            nav.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func convertDateFormate(date : Date) -> String {
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)

        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM, yyyy"
        let newDate = dateFormate.string(from: date)

        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
    
    @objc func btnBackTapped()
    {
        self.view.endEditing(true)
        
        if isModal() && !isForceModel
        {
            self.dismiss(animated: true) {
                
            }
        }
        else
        {
            if let vcArray = self.navigationController?.viewControllers
            {
                if vcArray.count > 1
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    
                }
            }
        }
    }
    
    
    
    
    func showTabbar()
    {
        if #available(iOS 13.0, *) {
            
            if let barCNT : tabBarMaster = UIApplication.shared.windows.first?.rootViewController as? tabBarMaster
            {
                barCNT.tabBar.isHidden = false
                //barCNT.showMiddleButton()
            }
            
        } else {
            // Fallback on earlier versions
            if let barCNT : tabBarMaster = UIApplication.shared.keyWindow?.rootViewController as? tabBarMaster
            {
                barCNT.tabBar.isHidden = false
                //barCNT.showMiddleButton()
            }
        }
    }
    func hideTabbar()
    {
        if #available(iOS 13.0, *) {
            
            if let barCNT : tabBarMaster = UIApplication.shared.windows.first?.rootViewController as? tabBarMaster
            {
                barCNT.tabBar.isHidden = true
                //barCNT.hideMiddleButton()
            }
            
        } else {
            // Fallback on earlier versions
            if let barCNT : tabBarMaster = UIApplication.shared.keyWindow?.rootViewController as? tabBarMaster
            {
                barCNT.tabBar.isHidden = true
                //barCNT.hideMiddleButton()
            }
        }
    }
    
    
    @IBOutlet var refreshView: LGRefreshView!
    var isRefresh = Bool()
    
    func setRefreshController(scrollView: UIScrollView)
    {
        self.refreshView = LGRefreshView(scrollView: scrollView, refreshHandler: { refreshView in
            
            self.isRefresh = true
            self.refreshCalled(res: true)
        })
        refreshView?.tintColor = APP_COL.App
        refreshView?.backgroundColor = UIColor.clear
    }
    
    @IBOutlet var refreshView_2: LGRefreshView!
    var isRefresh_2 = Bool()
    
    func setRefreshController_2(scrollView: UIScrollView)
    {
        self.refreshView_2 = LGRefreshView(scrollView: scrollView, refreshHandler: { refreshView in
            
            self.isRefresh_2 = true
            self.refreshCalled(res: true)
        })
        refreshView_2?.tintColor = APP_COL.App
        refreshView_2?.backgroundColor = UIColor.clear
    }
    
    func refreshCalled(res: Bool) {
        
    }
    
    
    func setNoData(scrollView: UIScrollView!) {
        
        scrollView.emptyDataSetSource = self
        scrollView.emptyDataSetDelegate = self
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = APP_LBL.No_data_found
        let attributes = [NSAttributedString.Key.foregroundColor:  APP_COL.No_Data_Found,
                          NSAttributedString.Key.font: APP_FUNC.getFont(for: FontName.Regular, size: Utility.NodataLabelSize())
        ]

        return NSAttributedString(string: text, attributes: attributes)
    }
    
//    internal func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
//    {
//
//        let text = APP_LBL.No_Data_Found
//        let attributes = [NSAttributedString.Key.foregroundColor:  APP_COL.No_Data_Found,
//                          NSAttributedString.Key.font: APP_FUNC.getFont(for: FontName.Regular, size: 22.0)
//        ]
//
//        return NSAttributedString(string: text, attributes: attributes)
//    }
    
    internal func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    
    
    
    
    
    func shareContent(text: String? = nil, image: UIImage? = nil, urlStr: String? = nil) {
        
        var shareAll : [Any?] = []
        
        if text != nil {
            shareAll.append(text)
        }
        
        if image != nil {
            shareAll.append(image)
        }
        
        if urlStr != nil {
            shareAll.append(URL(string: urlStr ?? ""))
        }
        
        let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    //Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.callEndEditing))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    @objc private func callEndEditing() {
        
        if isDismissOnTap {
            
            self.view.endEditing(true)
        }
    }
    
    @objc func btnBaseBackTapped(item: UIBarButtonItem)
    {
        self.manualyBtnBackTapped()
    }
    
    func manualyBtnBackTapped() {
        
        self.view.endEditing(true)
        
        if isModal() && !isForceModel
        {
            self.dismiss(animated: true) { }
        }
        else
        {
            if let vcArray = self.navigationController?.viewControllers, vcArray.count > 1
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
    
}
