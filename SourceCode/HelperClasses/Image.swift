//
//  Image.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit


var APP_IMG = Image.shared
struct Image
{
    private init() { }
    static let shared = Image()
    
    let user_placeholder: String = "profile-placeholder"
    let img_placeholder: String = "placeholder_Company"
    
    
    lazy var back_white_arrow: UIImage? = { return UIImage(named: "back_white_arrow") }()
    lazy var back_black_arrow: UIImage? = { return UIImage(named: "back_arrow") }()
    
    
    lazy var logo: UIImage? = { return UIImage(named: "logo") }()
    lazy var bg: UIImage? = { return UIImage(named: "bg") }()
    lazy var eye: UIImage? = { return UIImage(named: "eye") }()
    
    lazy var forgor_password: UIImage? = { return UIImage(named: "forgor_password") }()
    
    
    lazy var sel_profile: UIImage? = { return UIImage(named: "sel_profile") }()
    lazy var unsel_profile: UIImage? = { return UIImage(named: "unsel_profile") }()
    lazy var sel_project: UIImage? = { return UIImage(named: "sel_project") }()
    lazy var unsel_project: UIImage? = { return UIImage(named: "unsel_project") }()
    lazy var sel_attendance: UIImage? = { return UIImage(named: "sel_attendance") }()
    lazy var unsel_attendance: UIImage? = { return UIImage(named: "unsel_attendance") }()
    lazy var sel_notification: UIImage? = { return UIImage(named: "sel_notification") }()
    lazy var unsel_notification: UIImage? = { return UIImage(named: "unsel_notification") }()
    
    lazy var user: UIImage? = { return UIImage(named: "user") }()
    lazy var pin: UIImage? = { return UIImage(named: "pin") }()
    lazy var notes: UIImage? = { return UIImage(named: "notes") }()
    lazy var search: UIImage? = { return UIImage(named: "search") }()
    lazy var filter: UIImage? = { return UIImage(named: "filter") }()

    
    lazy var M_Change_Password : UIImage? = {  return UIImage(named: "Profile-password-slicing") }()
    lazy var M_Leaves : UIImage? = {  return UIImage(named: "leaves") }()
    lazy var M_License_Information : UIImage? = {  return UIImage(named: "license-agreement") }()
    lazy var M_Induction_Information : UIImage? = {  return UIImage(named: "induction") }()
    lazy var M_Terms_And_Condition : UIImage? = {  return UIImage(named: "privacy-policy") }()
    lazy var M_Privacy_Policy : UIImage? = {  return UIImage(named: "privacy-policy") }()
    lazy var M_Logout : UIImage? = {  return UIImage(named: "logout") }()
    
    lazy var arrow: UIImage? = { return UIImage(named: "arrow") }()
    lazy var email_icon: UIImage? = { return UIImage(named: "email-icon") }()
    lazy var phone: UIImage? = { return UIImage(named: "phone") }()
    lazy var edit_profile: UIImage? = { return UIImage(named: "edit-profile") }()
    
    
    lazy var leave_approval: UIImage? = { return UIImage(named: "leave-approval-icon") }()
    lazy var leave_cancel: UIImage? = { return UIImage(named: "leave-cancel") }()
    
    lazy var camera: UIImage? = { return UIImage(named: "camera") }()
    lazy var close: UIImage? = { return UIImage(named: "close") }()
    
    lazy var check_out: UIImage? = { return UIImage(named: "check_out") }()
    lazy var start_end_date: UIImage? = { return UIImage(named: "start-end-date") }()
    
    lazy var add_image_box: UIImage? = { return UIImage(named: "add-image-box") }()
    
    //lazy var temp: UIImage? = { return UIImage(named: "temp") }()
    
}
