//
//  API.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import Foundation
import UIKit

struct API_DOC {
    
    
    static let register : String = "register"
    static let login : String = "login"
    static let forgot_password : String = "forgotpassword"
    static let change_password : String = "changepassword"
    static let label : String = "label"
    static let verify_otp : String = "verify_otp"
    static let resend_otp : String = "resend_otp"
    static let createcompany : String = "createcompany"
    static let cms : String = "getcms"
    static let faq : String = "faq"
    static let logout : String = "logout"
    static let userProfile : String = "userprofile"
    static let towCategory : String = "towCategory"
    static let CompanyList : String = "CompanyList"
    static let userInquiry : String = "userInquiry"
    static let customerInquirylist : String = "customerInquirylist"
    static let companyInquirylist : String = "companyInquirylist"
    static let updateCompany : String = "updateCompany"
    static let updateUser : String = "updateUser"
    static let companydetails : String = "companydetails"
    static let updatepassword : String = "updatepassword"
    static let customerdetails : String = "customerdetails"
    static let viewProfile : String = "viewProfile"
    static let settings : String = "settings"
    
}


let API = API_HELPER.shared

class API_HELPER
{
    private init() { }
    static let shared = API_HELPER()
    
    lazy var decoder: JSONDecoder = { return JSONDecoder() }()
    
    func validateResCode(code: Int) -> Bool {
        
        var res = true
        
        if code == ResponseCodeType.accountInactive.rawValue || code == ResponseCodeType.tokenExpired.rawValue {
            
            APP_DEL.currentUser?.logout()
            res = false
        }
        
        return res
    }
    
    func getMessage(json: AnyObject?) -> String {
        
        if let jsonArr = json as? [[String:Any]], let mes = jsonArr.first?["message"] as? String {
            return mes
        }
        return APP_LBL.something_went_wrong
    }
    
    
    //MARK:- Label management
    func label(completion: @escaping (Bool, String?) -> ()) {

        let langInfo = APP_LANG.getLanguageInfo()
        
        var para : [String : String] = [:]
        //para["language_id"] = langInfo.langID
        para["updated_date"] = langInfo.updated_at
        
        WEB_SER.api_GET(task: API_DOC.label, param: para) { (json, data) in

            if json == nil || data == nil {
                completion(false, APP_LBL.something_went_wrong)
                return
            } else {
                
                if let arrJson : [[String : Any]] = json as? [[String : Any]], let respo = arrJson.first
                {
                    let cd = (respo["code"] as? Int)
                    let arr = respo["result"] as? [[String : Any]]
                    
                    if cd == 1, let lblDict = arr?.first {
                        
                        var arrLB : [LBL] = []
                        for (k,v) in lblDict {
                            let lb = LBL(key: k, value: (v as? String) ?? "")
                            arrLB.append(lb)
                        }
                        
                        print("LBL COUNT:-",arrLB.count)
                        APP_LANG.manageLabelList(list: arrLB)
                        APP_LANG.setLanguageID(langID: 0, updated_date: (respo["updated_date"] as? String) ?? "")
                        
                        completion(true, nil)
                    } else if cd == 1 {
                        completion(true, "")
                    } else if cd == 0 {
                        completion(false, APP_LBL.No_data_found)
                    }
                    
                } else {
                    completion(false, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    //MARK:- Settings
    func settings(param: [String : String], completion: @escaping (Settings?, String?) -> ()) {

        WEB_SER.api_POST(task: API_DOC.settings, param: param) { (json, data) in

            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {

                let arrMod = try! self.decoder.decode([SettingsModel].self, from: data!)

                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                    
                     if mod.code == 1 {
                         completion(mod.data?.first, nil)
                     } else if mod.code == 0 {
                         completion(nil, APP_LBL.No_data_found)
                     } else if mod.code == -5 {
                         completion(nil, APP_LBL.api_Cannot_connect_to_server)
                     } else {
                         completion(nil, self.getMessage(json: json))
                     }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    //MARK:- CMS
    
    func cms(param: [String : String], completion: @escaping (Cms?, String?) -> ()) {

        WEB_SER.api_POST(task: API_DOC.cms, param: param) { (json, data) in

            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {

                let arrMod = try! self.decoder.decode([CmsModel].self, from: data!)

                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                    
                     if mod.code == 1 {
                         completion(mod.data?.first, nil)
                     } else if mod.code == 0 {
                         completion(nil, APP_LBL.No_data_found)
                     } else if mod.code == -5 {
                         completion(nil, APP_LBL.api_Cannot_connect_to_server)
                     } else {
                         completion(nil, self.getMessage(json: json))
                     }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
    
    //MARK:- createcompany

    func createcompany(param: [String : String], dictImage: [String : UIImage],completion: @escaping (User?, String?) -> ()) {
        WEB_SER.api_POST(task: API_DOC.createcompany, param: param, dictImage: dictImage, progressCompletion: { (uploadProgress) in
            
        }) { (json, data) in
            
            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {
                
                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)
                
                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
                    
                    if mod.code == -1 {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else if mod.code == 0 {
                        completion(nil, APP_LBL.Invalid_username_or_password)
                    } else if mod.code == -2 {
                        completion(nil, APP_LBL.email_already_exist)
                    } else {
                        completion(mod.data?.first, nil)
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    //MARK:- Register

    func register(param: [String : String], dictImage: [String : UIImage],completion: @escaping (User?, String?) -> ()) {
        WEB_SER.api_POST(task: API_DOC.register, param: param, dictImage: dictImage, progressCompletion: { (uploadProgress) in
            
        }) { (json, data) in
            
            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {
                
                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)
                
                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
                    
                    if mod.code == -1 {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else if mod.code == 0 {
                        completion(nil, APP_LBL.something_went_wrong)
                    } else if mod.code == -2 {
                        completion(nil, APP_LBL.email_already_exist)
                    } else {
                        completion(mod.data?.first, nil)
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    //MARK:- View Profile
    
    func viewProfile(param: [String : String], completion: @escaping (User?, String?) -> ()) {

        WEB_SER.api_POST(task: API_DOC.viewProfile, param: param) { (json, data) in
            
            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {
                
                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)
                
                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
                    
                    if mod.code == -1 {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else if mod.code == 0 {
                        completion(nil, APP_LBL.something_went_wrong)
                    } else if mod.code == -2 {
                        completion(nil, APP_LBL.email_already_exist)
                    } else {
                        completion(mod.data?.first, nil)
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
    //MARK:- Login

    func login(param: [String : String], completion: @escaping (User?, String?) -> ()) {

        WEB_SER.api_POST(task: API_DOC.login, param: param) { (json, data) in

            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {

                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)

                if arrMod.count > 0, let mod = arrMod.first {
                    
                    if mod.code == 1 {
                        completion(mod.data?.first, nil)
                    } else if mod.code == 0 {
                        completion(nil, APP_LBL.Invalid_username_or_password)
                    }else if mod.code == -9 {
                        completion(mod.data?.first, "Inactive User")
                    }else if mod.code == 3 {
                        completion(nil, APP_LBL.Invalid_username_or_password)
                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else {
                        completion(nil, self.getMessage(json: json))
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
    //MARK:- Forgot Password

    func forgot_password(param: [String : String], completion: @escaping (User?, String?) -> ()) {

        WEB_SER.api_POST(task: API_DOC.forgot_password, param: param) { (json, data) in

            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {

                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)

                if arrMod.count > 0, let mod = arrMod.first{
                    
                    if mod.code == 1 {
                        completion(mod.data?.first, nil)
                    } else if mod.code == -5 {
                        completion(nil, APP_LBL.no_mobile_number_found_in_the_system)
                    } else if mod.code == -4 {
                        completion(nil, APP_LBL.error_while_send_mail)
                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else {
                        completion(nil, self.getMessage(json: json))
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
    //MARK:- Verify OTP

    func verify_otp(param: [String : String], completion: @escaping (User?, String?) -> ()) {

        WEB_SER.api_POST(task: API_DOC.verify_otp, param: param) { (json, data) in

            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {

                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)

                if arrMod.count > 0, let mod = arrMod.first {
                    
                    if mod.code == 1 {
                        completion(mod.data?.first, nil)
                    } else if mod.code == 0 {
                        completion(nil, APP_LBL.Invalid_username_or_password)
                    }else if mod.code == 3 {
                        completion(nil, APP_LBL.Invalid_username_or_password)
                    } else if mod.code == -8 {
                        completion(nil, APP_LBL.Invalid_OTP)
                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else {
                        completion(nil, self.getMessage(json: json))
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
    //MARK:- Resend OTP

    func resend_otp(param: [String : String], completion: @escaping (ResendOTP?, String?) -> ()) {

        WEB_SER.api_POST(task: API_DOC.resend_otp, param: param) { (json, data) in

            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {

                let arrMod = try! self.decoder.decode([ResendOTP].self, from: data!)

                if arrMod.count > 0, let mod = arrMod.first{
                    
                    if mod.code == 1 {
                        completion(mod, nil)
                    } else if mod.code == 0 {
                        completion(nil, APP_LBL.no_email_found_in_the_system)
                    } else if mod.code == -4 {
                        completion(nil, APP_LBL.error_while_send_mail)
                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else {
                        completion(nil, self.getMessage(json: json))
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
        //MARK:- Change Password
    
        func change_password(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
    
            WEB_SER.api_POST(task: API_DOC.change_password, param: param) { (json, data) in
    
                if json == nil || data == nil {
                    completion(nil, APP_LBL.something_went_wrong)
                    return
                } else {
    
                    let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
    
                    if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
    
                        if mod.code == ResponseCodeType.success.rawValue {
                            completion(mod, nil)
                        } else if mod.code == 0 {
                            completion(nil, APP_LBL.password_does_not_match)
                        } else if mod.code == -3 {
                            completion(nil, APP_LBL.password_does_not_match)
                        } else if mod.code == -4 {
                            completion(nil, APP_LBL.error_while_send_mail)
                        } else if mod.code == ResponseCodeType.accountInactive.rawValue {
                            completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                        } else {
                            completion(nil, self.getMessage(json: json))
                        }
    
                    } else {
                        completion(nil, APP_LBL.something_went_wrong)
                    }
                }
            }
        }
    
        func updatepassword(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
    
            WEB_SER.api_POST(task: API_DOC.updatepassword, param: param) { (json, data) in
    
                if json == nil || data == nil {
                    completion(nil, APP_LBL.something_went_wrong)
                    return
                } else {
    
                    let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
    
                    if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
    
                        if mod.code == ResponseCodeType.success.rawValue {
                            completion(mod, nil)
                        } else if mod.code == 0 {
                            completion(nil, APP_LBL.current_password_is_wrong)
                        } else if mod.code == -3 {
                            completion(nil, APP_LBL.password_does_not_match)
                        } else if mod.code == -4 {
                            completion(nil, APP_LBL.error_while_send_mail)
                        } else if mod.code == ResponseCodeType.accountInactive.rawValue {
                            completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                        } else {
                            completion(nil, self.getMessage(json: json))
                        }
    
                    } else {
                        completion(nil, APP_LBL.something_went_wrong)
                    }
                }
            }
        }
    
    //MARK:- CompanyList API
    func CompanyList(param: [String : String], completion: @escaping (CompanyListModel?, String?) -> ()) {
        
        WEB_SER.api_POST(task: API_DOC.CompanyList, param: param) { (json, data) in
            
            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {
                
                let arrMod = try! self.decoder.decode([CompanyListModel].self, from: data!)
                
                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                    
                    if mod.code == 1 {
                        completion(mod, nil)
                    } else if mod.code == 0 {
                        completion(mod, APP_LBL.No_data_found)
                    } else if mod.code == -7 {
                        completion(mod, APP_LBL.No_data_found)
                    }else {
                        completion(nil, self.getMessage(json: json))
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    //MARK:- towCategory
    func towCategory(param: [String : String], completion: @escaping (categoryModel?, String?) -> ()) {
        
        WEB_SER.api_POST(task: API_DOC.towCategory, param: param) { (json, data) in
            
            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {
                
                let arrMod = try! self.decoder.decode([categoryModel].self, from: data!)
                
                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                    
                    if mod.code == 1 {
                        completion(mod, nil)
                    } else if mod.code == 0 {
                        completion(mod, APP_LBL.No_data_found)
                    } else {
                        completion(nil, self.getMessage(json: json))
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
    //MARK:- Send Inquiry
        func userInquiry(param: [String : String], arrImage: NSArray,completion: @escaping (CodeModel?, String?) -> ()) {
            
            WEB_SER.POST_ArrUploadRequest(task: API_DOC.userInquiry, param: param, arrData: arrImage, progressCompletion:{ (uploadProgress) in
                
            }) { (json, data) in
                
                if json == nil || data == nil {
                    completion(nil, APP_LBL.something_went_wrong)
                    return
                } else {
                    
                    let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
                    
                    if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
                        
                        if mod.code == -1 {
                            completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                        } else if mod.code == 0 {
                            completion(nil, APP_LBL.something_went_wrong)
                        } else if mod.code == -2 {
                            completion(nil, APP_LBL.email_already_exist)
                        } else {
                            completion(mod, nil)
                        }
                        
                    } else {
                        completion(nil, APP_LBL.something_went_wrong)
                    }
                }
            }
        }
    
    //MARK:- My User Inquiry
    func customerInquirylist(param: [String : String], completion: @escaping (InquiryListModel?, String?) -> ()) {
        
        WEB_SER.api_POST(task: API_DOC.customerInquirylist, param: param) { (json, data) in
            
            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {
                
                let arrMod = try! self.decoder.decode([InquiryListModel].self, from: data!)
                
                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                    
                    if mod.code == 1 {
                        completion(mod, nil)
                    } else if mod.code == 0 {
                        completion(mod, APP_LBL.No_data_found)
                    } else if mod.code == -7 {
                        completion(mod, APP_LBL.No_data_found)
                    }else {
                        completion(nil, self.getMessage(json: json))
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
         //MARK:- My Company Inquiry
         func companyInquirylist(param: [String : String], completion: @escaping (CompanyInquiryListModel?, String?) -> ()) {
             
             WEB_SER.api_POST(task: API_DOC.companyInquirylist, param: param) { (json, data) in
                 
                 if json == nil || data == nil {
                     completion(nil, APP_LBL.something_went_wrong)
                     return
                 } else {
                     
                     let arrMod = try! self.decoder.decode([CompanyInquiryListModel].self, from: data!)
                     
                     if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                         
                         if mod.code == 1 {
                             completion(mod, nil)
                         } else if mod.code == -7 {
                             completion(mod, APP_LBL.No_data_found)
                         } else {
                             completion(nil, self.getMessage(json: json))
                         }
                         
                     } else {
                         completion(nil, APP_LBL.something_went_wrong)
                     }
                 }
             }
         }
    //MARK:- Update company Profile

    func updateCompany(param: [String : String], dictImage: [String : UIImage],completion: @escaping (User?, String?) -> ()) {
        WEB_SER.api_POST(task: API_DOC.updateCompany, param: param, dictImage: dictImage, progressCompletion: { (uploadProgress) in
            
        }) { (json, data) in
            
            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {
                
                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)
                
                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
                    
                    if mod.code == -1 {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else if mod.code == 0 {
                        completion(nil, APP_LBL.something_went_wrong)
                    } else if mod.code == -2 {
                        completion(nil, APP_LBL.email_already_exist)
                    } else {
                        completion(mod.data?.first, nil)
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
    //MARK:- Update User Profile

    func updateUser(param: [String : String], dictImage: [String : UIImage],completion: @escaping (User?, String?) -> ()) {
        WEB_SER.api_POST(task: API_DOC.updateUser, param: param, dictImage: dictImage, progressCompletion: { (uploadProgress) in
            
        }) { (json, data) in
            
            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {
                
                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)
                
                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
                    
                    if mod.code == -1 {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else if mod.code == 0 {
                        completion(nil, APP_LBL.Invalid_username_or_password)
                    } else if mod.code == -2 {
                        completion(nil, APP_LBL.email_already_exist)
                    } else {
                        completion(mod.data?.first, nil)
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
    
    //MARK:- Company Inquiry Detail
           func companydetails(param: [String : String], completion: @escaping (CompanyDetailModel?, String?) -> ()) {
               
               WEB_SER.api_POST(task: API_DOC.companydetails, param: param) { (json, data) in
                   
                   if json == nil || data == nil {
                       completion(nil, APP_LBL.something_went_wrong)
                       return
                   } else {
                       
                       let arrMod = try! self.decoder.decode([CompanyDetailModel].self, from: data!)
                       
                       if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                           
                           if mod.code == 1 {
                               completion(mod, nil)
                           } else if mod.code == 0 {
                               completion(mod, APP_LBL.No_data_found)
                           } else {
                               completion(nil, self.getMessage(json: json))
                           }
                           
                       } else {
                           completion(nil, APP_LBL.something_went_wrong)
                       }
                   }
               }
           }
    //MARK:- User Inquiry Detail
           func customerdetails(param: [String : String], completion: @escaping (CustomerDetailModel?, String?) -> ()) {
               
               WEB_SER.api_POST(task: API_DOC.customerdetails, param: param) { (json, data) in
                   
                   if json == nil || data == nil {
                       completion(nil, APP_LBL.something_went_wrong)
                       return
                   } else {
                       
                       let arrMod = try! self.decoder.decode([CustomerDetailModel].self, from: data!)
                       
                       if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                           
                           if mod.code == 1 {
                               completion(mod, nil)
                           } else if mod.code == 0 {
                               completion(mod, APP_LBL.No_data_found)
                           } else {
                               completion(nil, self.getMessage(json: json))
                           }
                           
                       } else {
                           completion(nil, APP_LBL.something_went_wrong)
                       }
                   }
               }
           }
    
        //MARK:- Start Trip
    
        func logoutAPI(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
    
              WEB_SER.api_POST(task: API_DOC.logout, param: param) { (json, data) in
    
                  if json == nil || data == nil {
                      completion(nil, APP_LBL.something_went_wrong)
                      return
                  } else {
    
                      let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
    
                      if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
    
                          if mod.code == 1 {
                              completion(mod, nil)
                          }else if mod.code == ResponseCodeType.accountInactive.rawValue {
                              completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                          } else{
                              completion(nil, self.getMessage(json: json))
                          }
    
                      } else {
                          completion(nil, APP_LBL.something_went_wrong)
                      }
                  }
              }
          }
    
    //MARK:- FAQ

    func faq(param: [String : String], completion: @escaping (FAQModell?, String?) -> ()) {

        WEB_SER.api_POST(task: API_DOC.faq, param: param) { (json, data) in

            if json == nil || data == nil {
                completion(nil, APP_LBL.something_went_wrong)
                return
            } else {

                let arrMod = try! self.decoder.decode([FAQModell].self, from: data!)

                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code!) {
                    
                    if mod.code == 1 {
                        completion(mod, nil)
                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
                    } else {
                        completion(nil, self.getMessage(json: json))
                    }
                    
                } else {
                    completion(nil, APP_LBL.something_went_wrong)
                }
            }
        }
    }
//    //MARK:- Follow User
//
//    
//    func followUser(param: [String : String], completion: @escaping (UserListModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.follow_user, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([UserListModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    func removeFollowerAPI(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.removeFollower, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    func APICalledFollow( toId : String, presentVC : UIViewController , completion: @escaping ( UserListModel? ) -> () ){
//        
//        let param : NSDictionary = [
//            "user_id": "\(APP_DEL.currentUser?.user_id ?? 0)" ,
//            "token": APP_DEL.currentUser?.token ?? "",
//            "to_id":toId
//        ]
//        
//        followUser(param: param as! [String : String]) { (responseData, resString) in
//            if responseData == nil {
//                presentVC.showAlert(message: resString ?? APP_LBL.something_went_wrong)
//                completion(nil)
//            }else{
//                completion(responseData)
//            }
//        }
//        
//    }
//    
//    func APIRemoveFollower(reqId : String, presentVC : UIViewController , completion: @escaping ( CodeModel? ) -> () ){
//        
//        let param : NSDictionary = [
//            "user_id": "\(APP_DEL.currentUser?.user_id ?? 0)" ,
//            "token": APP_DEL.currentUser?.token ?? "",
//            "req_id":reqId
//        ]
//        
//        removeFollowerAPI(param: param as! [String : String]) { (responseData, resString) in
//            if responseData == nil {
//                presentVC.showAlert(message: resString ?? APP_LBL.something_went_wrong)
//                completion(nil)
//            }else{
//                completion(responseData)
//            }
//        }
//        
//    }
//    
//    
//    //MARK:- Report User
//
//      
//      func reportUser(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.reportUser, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      } else if mod.code == 0 {
//                          completion(mod, APP_LBL.post_already_been_reported)
//                      } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      }  else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    
//    //MARK:- Report Post
//
//      func reportPost(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.reportPost, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    
//    
//    
//    //MARK:- Like Post
//
//    func LikePost(param: [String : String], completion: @escaping (AddLikeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.likepost, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([AddLikeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//      
//    //MARK:- Create Post
//
//    func create_post(param: [String : String], completion: @escaping (FeedModel?, String?) -> ()) {
//
//        WEB_SER.api_POST(task: API_DOC.create_post, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([FeedModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    

//    
//
//    
//        //MARK:- View Profile
//
//    func view_profile(param: [String : String], completion: @escaping (User?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.view_profile, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod.result?.first, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Update Profile
//
//    func update_profile(param: [String : String], completion: @escaping (User?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.update_profile, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod.result?.first, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == 2 {
//                        completion(nil, APP_LBL.something_went_wrong)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Update Profile Picture
//
//    func update_profile_picture(param: [String : String], completion: @escaping (UpdatePicture?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.update_profile_picture, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([UpdatePictureModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod.result?.first, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == 2 {
//                        completion(nil, APP_LBL.something_went_wrong)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Post List
//
//    func post_list(param: [String : String], completion: @escaping (FeedModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.post_list, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                do {
//                    let arrMod = try self.decoder.decode([FeedModel].self, from: data!)
//
//                    if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                        
//                        if mod.code == ResponseCodeType.success.rawValue {
//                            completion(mod, nil)
//                        } else if mod.code == 0 {
//                            completion(mod, APP_LBL.api_No_data_found)
//                        } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                            completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                        } else {
//                            completion(nil, self.getMessage(json: json))
//                        }
//                        
//                    } else {
//                        completion(nil, APP_LBL.something_went_wrong)
//                    }
//                } catch {
//                    completion(nil, APP_LBL.something_went_wrong)
//
//                }
//            }
//        }
//    }
//    
//    //MARK:- Explore Photos Post List
//
//    func explore_photos_post_list(param: [String : String], completion: @escaping (ExplorePhotoModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.explore, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([ExplorePhotoModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == 0 {
//                        completion(mod, APP_LBL.api_No_data_found)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Explore Videos Post List
//
//    func explore_videos_post_list(param: [String : String], completion: @escaping (FeedModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.explore, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([FeedModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == 0 {
//                        completion(mod, APP_LBL.api_No_data_found)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Explore Trip List
//
//       func explore_trip_list(param: [String : String], completion: @escaping (TripDetailModel?, String?) -> ()) {
//
//           WEB_SER.api_GET(task: API_DOC.explore, param: param) { (json, data) in
//
//               if json == nil || data == nil {
//                   completion(nil, APP_LBL.something_went_wrong)
//                   return
//               } else {
//
//                   let arrMod = try! self.decoder.decode([TripDetailModel].self, from: data!)
//
//                   if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                       
//                       if mod.code == ResponseCodeType.success.rawValue {
//                           completion(mod, nil)
//                       } else if mod.code == 0 {
//                           completion(mod, APP_LBL.api_No_data_found)
//                       } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                           completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                       } else {
//                           completion(nil, self.getMessage(json: json))
//                       }
//                       
//                   } else {
//                       completion(nil, APP_LBL.something_went_wrong)
//                   }
//               }
//           }
//       }
//    
//    //MARK:- Event List
//
//    func explore_event_list(param: [String : String], completion: @escaping (EventMainModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.explore, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([EventMainModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Post Details
//    
//    func PostDetails(param: [String : String], completion: @escaping (FeedModel?, String?) -> ()){
//        WEB_SER.api_GET(task: API_DOC.post_details, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([FeedModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                          
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == 0 {
//                        completion(mod, APP_LBL.api_No_data_found)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                   
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Add Comment
//
//    func addComment(param: [String : String], completion: @escaping (AddCommentModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.addcomment, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([AddCommentModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Delete Comment
//
//    func deleteComment(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.deleteComment, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    //MARK:- Delete Review
//
//    func deleteReviewFromPlace(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.deleteReview, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    //MARK:- Delete Post
//
//      func deletePost(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.deletepost, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == ResponseCodeType.success.rawValue {
//                          completion(mod, nil)
//                      } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      }  else {
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Comment List
//
//    func CommentList(param: [String : String], completion: @escaping (CommentModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.commentList, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([CommentModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == ResponseCodeType.success.rawValue {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     }  else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    //MARK:- Like List
//
//     func LikeList(param: [String : String], completion: @escaping (UserListModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.postlikelist, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([UserListModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == ResponseCodeType.success.rawValue {
//                          completion(mod, nil)
//                      } else if mod.code == 0 {
//                          completion(mod, APP_LBL.api_No_data_found)
//                      } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      }  else {
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Follower Following List
//
//        func FollowerFollowingList(param: [String : String], completion: @escaping (UserListModel?, String?) -> ()) {
//
//             WEB_SER.api_GET(task: API_DOC.followlist, param: param) { (json, data) in
//
//                 if json == nil || data == nil {
//                     completion(nil, APP_LBL.something_went_wrong)
//                     return
//                 } else {
//
//                     let arrMod = try! self.decoder.decode([UserListModel].self, from: data!)
//
//                     if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                         
//                         if mod.code == ResponseCodeType.success.rawValue {
//                             completion(mod, nil)
//                         } else if mod.code == 0 {
//                             completion(mod, APP_LBL.api_No_data_found)
//                         } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                             completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                         }  else {
//                             completion(nil, self.getMessage(json: json))
//                         }
//                         
//                     } else {
//                         completion(nil, APP_LBL.something_went_wrong)
//                     }
//                 }
//             }
//         }
//     
//    
//    //MARK:- search user List
//
//    func SearchUserList(param: [String : String], completion: @escaping (UserListModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.searchuser, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([UserListModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == ResponseCodeType.success.rawValue {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    
//    //MARK:- Follow Request List
//
//    func followRequestList(param: [String : String], completion: @escaping (FollowReqModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.follow_reqest_list, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([FollowReqModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == ResponseCodeType.success.rawValue {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    //MARK:- Blocked User List
//
//    func blockedUserList(param: [String : String], completion: @escaping (FollowReqModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.blockList, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([FollowReqModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == ResponseCodeType.success.rawValue {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    //MARK:- Event Join Request List
//
//    func eventJoinRequestList(param: [String : String], completion: @escaping (FollowReqModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.requestList, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([FollowReqModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == ResponseCodeType.success.rawValue {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    //MARK:- Group Join Request List
//
//    func groupJoinRequestList(param: [String : String], completion: @escaping (FollowReqModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.groupInviteList, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([FollowReqModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == ResponseCodeType.success.rawValue {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    //MARK:- Notification List
//
//    func notification_list(param: [String : String], completion: @escaping (NotificModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.notification_list, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([NotificModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == 0 {
//                        completion(mod, APP_LBL.api_No_data_found)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    }  else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    

//    
//    

//    //MARK:- Notification count
//
//    func notification_count(param: [String : String], completion: @escaping (NotificCountModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.notification_count, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([NotificCountModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//   
//    //MARK :- Chat API's
//    
////    func conversationList(param: [String : String], completion: @escaping (ConversationModel?, String?) -> ()) {
////
////        WEB_SER.api_GET(task: API_DOC.chat_messages, param: param) { (json, data) in
////
////            if json == nil || data == nil {
////                completion(nil, APP_LBL.something_went_wrong)
////                return
////            } else {
////
////                let arrMod = try! self.decoder.decode([ConversationModel].self, from: data!)
////
////                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
////
////                    if mod.code == 1 {
////                        completion(mod, nil)
////                    } else if mod.code == 0 {
////                        completion(mod, APP_LBL.api_No_data_found)
////                    } else {
////                        completion(nil, self.getMessage(json: json))
////                    }
////
////                } else {
////                    completion(nil, APP_LBL.something_went_wrong)
////                }
////            }
////        }
////    }
////
////
////
////       func messagesList(param: [String : String], completion: @escaping (ChatMessageModel?, String?) -> ()) {
////
////           WEB_SER.api_GET(task: API_DOC.view_user_chat, param: param) { (json, data) in
////
////               if json == nil || data == nil {
////                   completion(nil, APP_LBL.something_went_wrong)
////                   return
////               } else {
////
////                   let arrMod = try! self.decoder.decode([ChatMessageModel].self, from: data!)
////
////                   if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
////
////                       if mod.code == 1 {
////                           completion(mod, nil)
////                       } else if mod.code == 0 {
////                           completion(mod, APP_LBL.api_No_data_found)
////                       } else {
////                           completion(nil, self.getMessage(json: json))
////                       }
////
////                   } else {
////                       completion(nil, APP_LBL.something_went_wrong)
////                   }
////               }
////           }
////       }
//
//    
//    //MARK :- MAPBOX API
//    func searchForwardAPI(searchStr : String, param: [String : String], completion: @escaping ([[String : Any]]?, String?) -> ()) {
//
//        let searchString = "https://api.mapbox.com/geocoding/v5/mapbox.places/\(searchStr).json?access_token=\(MapBoxPublickKey)"
//        WEB_SER.api_GET_WithoutBaseUrl(task: searchString, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//                print("searchForwardAPI Response : \(String(describing: json))")
//                if let jsonDict = json as? [String : Any] {
//                    if let featureArray = jsonDict["features"] as? [[String : Any]] {
//                        completion(featureArray, self.getMessage(json: json))
//                        return
//                    }
//                }
//                
//            completion(nil, "No data found")
//
////                let arrMod = try! self.decoder.decode([UserModel].self, from: data!)
//
////                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
////
////                    if mod.code == 4 {
////                        completion(mod.result?.first, nil)
////                    } else if mod.code == 3 {
////                        completion(nil, APP_LBL.invalid_username_or_password)
////                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
////                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
////                    } else {
////                        completion(nil, self.getMessage(json: json))
////                    }
////
////                } else {
////                    completion(nil, APP_LBL.something_went_wrong)
////                }
//            }
//        }
//    }
//    
//        //MARK :- MAPBOX API
//        func searchForwardLocationBaseAPI(searchStr : String, param: [String : String], completion: @escaping (MapboxPlaceModel?, String?) -> ()) {
//
//            let searchString = "https://api.mapbox.com/geocoding/v5/mapbox.places/\(searchStr).json?access_token=\(MapBoxPublickKey)"
//
//            WEB_SER.api_GET_WithoutBaseUrl(task: searchString, param: param) { (json, data) in
//
//                if json == nil || data == nil {
//                    completion(nil, APP_LBL.something_went_wrong)
//                    return
//                } else {
//                    print("searchForwardAPI Response : \(String(describing: json))")
//                    do {
//                        let arrMod = try self.decoder.decode(MapboxPlaceModel.self, from: data!)
//                        completion(arrMod, nil)
//                    } catch {
//                        completion(nil, APP_LBL.something_went_wrong)
//                    }
//
//                }
//            }
//        }
//    
//    
//    
//    //MARK:- Trip Module Start
//
//    
//    //MARK:- Comment List
//
//    func CategoryList(param: [String : String], completion: @escaping (CategoryModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.categoryList, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([CategoryModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == 1 {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    //MARK:- Place List
//
//    func PlaceList(param: [String : String], completion: @escaping (PlaceModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.placeList, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([PlaceModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == 1 {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    
//    //MARK:- Recent and Popular Place List
//
//    func recentAndPopularPlaceList(param: [String : String], completion: @escaping (RecentPlaceModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.searchPlaceList, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([RecentPlaceModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == 1 {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    
//    //MARK:- Friend List for invitation
//
//     func FriendListForInvitation(param: [String : String], completion: @escaping (UserListModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.friendList, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([UserListModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      } else if mod.code == 0 {
//                          completion(mod, APP_LBL.api_No_data_found)
//                      } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else {
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Friend List for invitation
//
//     func TripMemberList(param: [String : String], completion: @escaping (TripMemberListModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.tripMember, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([TripMemberListModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      } else if mod.code == 0 {
//                          completion(mod, APP_LBL.api_No_data_found)
//                      } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else {
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    
//    //MARK:- Create and Edit Trip Post
//
//    func createEditTrip(param: [String : String], completion: @escaping (TripDetailModel?, String?) -> ()) {
//        print("createEditTrip Param : \(param) and URL = API_DOC.createTrip")
//
//        WEB_SER.api_POST(task: API_DOC.createTrip, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([TripDetailModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    //MARK:- Create and Edit Trip Post
//
//    func tripDetail(param: [String : String], completion: @escaping (TripDetailModel?, String?) -> ()) {
//        print("createEditTrip Param : \(param) and URL = \(API_DOC.tripDetail)")
//
//        WEB_SER.api_GET(task: API_DOC.tripDetail, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([TripDetailModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == ResponseCodeType.tripNotFound.rawValue {
//                        completion(nil, APP_LBL.trip_not_available_anymore)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Create and Edit Trip Post
//
//    func createSameTrip(param: [String : String], completion: @escaping (TripDetailModel?, String?) -> ()) {
//        print("createEditTrip Param : \(param) and URL = \(API_DOC.tripDetail)")
//
//        WEB_SER.api_GET(task: API_DOC.createSameTrip, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([TripDetailModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    //MARK:- Send or Cancel sent Invitation
//
//    func inviteFriend(param: [String : String], completion: @escaping (UserListModel?, String?) -> ()) {
//
//         WEB_SER.api_GET(task: API_DOC.inviteFriends, param: param) { (json, data) in
//
//             if json == nil || data == nil {
//                 completion(nil, APP_LBL.something_went_wrong)
//                 return
//             } else {
//
//                 let arrMod = try! self.decoder.decode([UserListModel].self, from: data!)
//
//                 if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                     
//                     if mod.code == 1 {
//                         completion(mod, nil)
//                     } else if mod.code == 0 {
//                         completion(mod, APP_LBL.api_No_data_found)
//                     } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                         completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                     } else {
//                         completion(nil, self.getMessage(json: json))
//                     }
//                     
//                 } else {
//                     completion(nil, APP_LBL.something_went_wrong)
//                 }
//             }
//         }
//     }
//    
//    //MARK:- Create and Edit Trip Post
//
//    func getTripList(param: [String : String], completion: @escaping (TripDetailModel?, String?) -> ()) {
//        print("createEditTrip Param : \(param) and URL = API_DOC.tripList")
//
//        WEB_SER.api_GET(task: API_DOC.tripList, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([TripDetailModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    //MARK:- Accept Reject Follow Requests
//
//    func acceptRejectFollowReq(param: [String : String], completion: @escaping (FollowReqModel?, String?) -> ()) {
//        print("createEditTrip Param : \(param) and URL = API_DOC.tripList")
//
//        WEB_SER.api_GET(task: API_DOC.acceptReject, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([FollowReqModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Accept Reject Follow Requests
//
//       func acceptRejectTripReq(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//           print("createEditTrip Param : \(param) and URL = API_DOC.tripList")
//
//           WEB_SER.api_GET(task: API_DOC.acceptRejectTripInvite, param: param) { (json, data) in
//
//               if json == nil || data == nil {
//                   completion(nil, APP_LBL.something_went_wrong)
//                   return
//               } else {
//
//                   let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                   if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                       
//                       if mod.code == 1 {
//                           completion(mod, nil)
//                       }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                           completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                       } else{
//                           completion(nil, self.getMessage(json: json))
//                       }
//                       
//                   } else {
//                       completion(nil, APP_LBL.something_went_wrong)
//                   }
//               }
//           }
//       }
//    
//    //MARK:- Report Trip reason List
//
//    func report_reason_list(param: [String : String], completion: @escaping (ReportTripModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.reportList, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([ReportTripModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == 0 {
//                        completion(mod, APP_LBL.api_No_data_found)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Report Post
//
//    func reportTrip(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.reportTrip, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Trip Delete
//
//    func callDeleteTrip(param: [String : String], completion: @escaping (GeneralTripCodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.deleteTrip, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([GeneralTripCodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Trip End
//
//    func callEndTrip(param: [String : String], completion: @escaping (GeneralTripCodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.endTrip, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([GeneralTripCodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Call off trip
//
//    func callOffTrip(param: [String : String], completion: @escaping (GeneralTripCodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.callOffTrip, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([GeneralTripCodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Trip KM Upadte
//
//    func updateKMTrip(param: [String : String], completion: @escaping (GeneralTripCodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.updateTripKm, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([GeneralTripCodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Report Post
//
//       func addRecentSearchPlace(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//           WEB_SER.api_GET(task: API_DOC.addRecentSearchPlace, param: param) { (json, data) in
//
//               if json == nil || data == nil {
//                   completion(nil, APP_LBL.something_went_wrong)
//                   return
//               } else {
//
//                   let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                   if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                       
//                       if mod.code == 1 {
//                           completion(mod, nil)
//                       } else{
//                           completion(nil, self.getMessage(json: json))
//                       }
//                       
//                   } else {
//                       completion(nil, APP_LBL.something_went_wrong)
//                   }
//               }
//           }
//       }
//    
//    //MARK:- Report Place Detail Photo
//
//       func reportMedia(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//           WEB_SER.api_GET(task: API_DOC.reportMedia, param: param) { (json, data) in
//
//               if json == nil || data == nil {
//                   completion(nil, APP_LBL.something_went_wrong)
//                   return
//               } else {
//
//                   let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                   if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                       
//                       if mod.code == 1 {
//                           completion(mod, nil)
//                       } else{
//                           completion(nil, self.getMessage(json: json))
//                       }
//                       
//                   } else {
//                       completion(nil, APP_LBL.something_went_wrong)
//                   }
//               }
//           }
//       }
//    
//    //MARK:- Like Post
//
//    func LikeTrip(param: [String : String], completion: @escaping (AddLikeTripModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.favouriteTrip, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([AddLikeTripModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Delete Post
//
//         func setDatePlaceTrip(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//             WEB_SER.api_GET(task: API_DOC.setDatePlaceTrip, param: param) { (json, data) in
//
//                 if json == nil || data == nil {
//                     completion(nil, APP_LBL.something_went_wrong)
//                     return
//                 } else {
//
//                     let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                     if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                         
//                         if mod.code == 1 {
//                             completion(mod, nil)
//                         }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                             completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                         } else{
//                             completion(nil, self.getMessage(json: json))
//                         }
//                         
//                     } else {
//                         completion(nil, APP_LBL.something_went_wrong)
//                     }
//                 }
//             }
//         }
//    
//    
//    //MARK:- Place Detail
//
//    func placeDetail(param: [String : String], completion: @escaping (DetailModel?, String?) -> ()) {
//        print("createEditTrip Param : \(param) and URL = \(API_DOC.placeDetail)")
//
//        WEB_SER.api_GET(task: API_DOC.placeDetail, param: param) { (json, data) in
////http://socialbug.vrinsoft.in/public/api/placedetail?user_id=101&token=2ec81b51d86fe8efef09aa1f06a393a3&place_id=1
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([DetailModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == -6 {
//                        completion(nil, APP_LBL.post_not_available_anymore)
//                    }else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Add place review Post
//
//         func addReviewInPlace(param: [String : String], completion: @escaping (ReviewModel?, String?) -> ()) {
//            print("createEditTrip Param : \(param) and URL = \(API_DOC.addPlaceReview)")
//
//             WEB_SER.api_GET(task: API_DOC.addPlaceReview, param: param) { (json, data) in
//
//                 if json == nil || data == nil {
//                     completion(nil, APP_LBL.something_went_wrong)
//                     return
//                 } else {
//
//                     let arrMod = try! self.decoder.decode([ReviewModel].self, from: data!)
//
//                     if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                         
//                         if mod.code == 1 {
//                             completion(mod, nil)
//                         }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                             completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                         } else if mod.code == ResponseCodeType.failure.rawValue {
//                             completion(nil, APP_LBL.review_already_added_for_this_place)
//                         } else{
//                             completion(nil, self.getMessage(json: json))
//                         }
//                         
//                     } else {
//                         completion(nil, APP_LBL.something_went_wrong)
//                     }
//                 }
//             }
//         }
//    
//    //MARK:- Get place review list
//
//    
//    func getReviewListInPlace(param: [String : String], completion: @escaping (ReviewModel?, String?) -> ()) {
//       print("createEditTrip Param : \(param) and URL = \(API_DOC.placeReview)")
//
//        WEB_SER.api_GET(task: API_DOC.placeReview, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([ReviewModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Like Place
//
//    func LikePlace(param: [String : String], completion: @escaping (AddLikeTripModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.likePlace, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([AddLikeTripModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Update Profile
//
//    func addPhotoInPlace(param: [String : String], completion: @escaping (PlaceGalleryModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.addPlaceImage, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([PlaceGalleryModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == 2 {
//                        completion(nil, APP_LBL.something_went_wrong)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    func getPlaceGallery(param: [String : String], completion: @escaping (PlaceGalleryModel?, String?) -> ()) {
//       print("createEditTrip Param : \(param) and URL = \(API_DOC.placeGallery)")
//
//        WEB_SER.api_GET(task: API_DOC.placeGallery, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([PlaceGalleryModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Notification List
//
//        func NotificationList(param: [String : String], completion: @escaping (NotificationModel?, String?) -> ()) {
//
//             WEB_SER.api_GET(task: API_DOC.notificationList, param: param) { (json, data) in
//
//                 if json == nil || data == nil {
//                     completion(nil, APP_LBL.something_went_wrong)
//                     return
//                 } else {
//
//                     let arrMod = try! self.decoder.decode([NotificationModel].self, from: data!)
//
//                     if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                         
//                         if mod.code == 1 {
//                             completion(mod, nil)
//                         } else if mod.code == 0 {
//                             completion(mod, APP_LBL.api_No_data_found)
//                         } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                             completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                         } else {
//                             completion(nil, self.getMessage(json: json))
//                         }
//                         
//                     } else {
//                         completion(nil, APP_LBL.something_went_wrong)
//                     }
//                 }
//             }
//         }
//    
//    
//    
//    //MARK:- Start Trip
//
//    func StartTrip(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.startTrip, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    

//    
//    // MARK:- CREATE GROUP
//
//    func create_group(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//
//        WEB_SER.api_POST(task: API_DOC.createGroup, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- User Profile Details
//
//      func userProfileDetails(param: [String : String], completion: @escaping (UserProfileDataModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.userProfile, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([UserProfileDataModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      }  else {
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Create Event
//
//    func create_event(param: [String : String], completion: @escaping (EventMainModel?, String?) -> ()) {
//
//        WEB_SER.api_POST(task: API_DOC.createEvent, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([EventMainModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    //MARK:- Event List
//
//    func get_my_events(param: [String : String], completion: @escaping (EventMainModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.eventList, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([EventMainModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Event Details
//
//    func get_event_details(param: [String : String], completion: @escaping (EventMainModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.eventDetail, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([EventMainModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == ResponseCodeType.eventNotFound.rawValue {
//                        completion(nil, APP_LBL.event_not_found)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    //MARK:- Home Group
//
//    func grouphomescreen(param: [String : String], completion: @escaping (GroupModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.grouphomescreen, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([GroupModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    //MARK:- Group List
//
//    func grouplist(param: [String : String], completion: @escaping (HomeGroupListModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.grouplist, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([HomeGroupListModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Accept Reject Event Requests
//
//    func acceptRejectEventReq(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//        print("acceptRejectEventReq Param : \(param) and URL = API_DOC.tripList")
//
//        WEB_SER.api_GET(task: API_DOC.acceptInviteEvent, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == ResponseCodeType.eventAttendesCountExceeds.rawValue {
//                        completion(nil, APP_LBL.alert_number_attendes_exceeds)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Accept Reject Group Requests
//
//    func acceptRejectGroupReq(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//        print("acceptRejectGroupReq Param : \(param) and URL = API_DOC.acceptInviteEvent")
//
//        WEB_SER.api_GET(task: API_DOC.acceptRejectGroup, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == ResponseCodeType.groupNotFound.rawValue {
//                        completion(nil, APP_LBL.alert_number_attendes_exceeds)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Accept Reject Group Requests
//
//    func acceptRejectGroupJoinReq(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//        print("acceptRejectGroupReq Param : \(param) and URL = API_DOC.acceptInviteEvent")
//
//        WEB_SER.api_GET(task: API_DOC.acceptRejectJoin, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == ResponseCodeType.groupNotFound.rawValue {
//                        completion(nil, APP_LBL.alert_number_attendes_exceeds)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    
//    
//    //MARK:- Group Detail
//
//    func groupdetails(param: [String : String], completion: @escaping (GroupDetail?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.groupdetails, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([NewGroupDetailModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod.data?.first, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == ResponseCodeType.groupNotFound.rawValue {
//                        completion(nil, APP_LBL.group_not_found)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- LEAVE GROUP
//
//    func leaveGroupReq(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//        print("leaveGroupReq Param : \(param) and URL = API_DOC.acceptInviteEvent")
//
//        WEB_SER.api_GET(task: API_DOC.leaveGroup, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == ResponseCodeType.eventAttendesCountExceeds.rawValue {
//                        completion(nil, APP_LBL.alert_number_attendes_exceeds)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- DELETE GROUP
//
//    func deleteGroupReq(param: [String : String], completion: @escaping (CodeModel?, String?) -> ()) {
//        print("deleteGroup Param : \(param) and URL = API_DOC.deleteGroup")
//
//        WEB_SER.api_GET(task: API_DOC.deleteGroup, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CodeModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else if mod.code == ResponseCodeType.eventAttendesCountExceeds.rawValue {
//                        completion(nil, APP_LBL.alert_number_attendes_exceeds)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Delete Event
//
//    func delete_events(param: [String : String], completion: @escaping (EventMainModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.deleteEvent, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([EventMainModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, APP_LBL.event_successfully_deleted)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Send Join Request Event
//
//    func sendJoinRequestForEventByUser(param: [String : String], completion: @escaping (GeneralTripCodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.joinEvent, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([GeneralTripCodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      } else if mod.code == ResponseCodeType.eventAttendesCountExceeds.rawValue {
//                          completion(nil, APP_LBL.alert_number_attendes_exceeds)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Accept Reject Join Event Requests
//
////    func acceptRejectJoinEventReq(param: [String : String], completion: @escaping (FollowReqModel?, String?) -> ()) {
////        print("createEditTrip Param : \(param) and URL = API_DOC.tripList")
////
////        WEB_SER.api_GET(task: API_DOC.acceptReject, param: param) { (json, data) in
////
////            if json == nil || data == nil {
////                completion(nil, APP_LBL.something_went_wrong)
////                return
////            } else {
////
////                let arrMod = try! self.decoder.decode([FollowReqModel].self, from: data!)
////
////                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
////
////                    if mod.code == 1 {
////                        completion(mod, nil)
////                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
////                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
////                    } else{
////                        completion(nil, self.getMessage(json: json))
////                    }
////
////                } else {
////                    completion(nil, APP_LBL.something_went_wrong)
////                }
////            }
////        }
////    }
//    
//    
//    //MARK:- Calendar Month EVENT AND TRIP Count list
//
//    func get_calendar_trip_event_count(param: [String : String], completion: @escaping (CalendarModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.calendarEventTripCount, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CalendarModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    func homesearch(param: [String : String], completion: @escaping (HomeSearchModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.homesearch, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([HomeSearchModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else{
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Send Join Request Group
//
//    func sendJoinRequestForGroupByUser(param: [String : String], completion: @escaping (GeneralTripCodeModel?, String?) -> ()) {
//
//          WEB_SER.api_GET(task: API_DOC.joinGroup, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([GeneralTripCodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
//    
//    //MARK:- Event Trip calendar List
//
//    func eventTripCalendarList(param: [String : String], completion: @escaping (CalendarDateModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.calendardetail, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([CalendarDateModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Send Join Request Event
//
//     func sendBlockUserRequest(param: [String : String], completion: @escaping (GeneralTripCodeModel?, String?) -> ()) {
//
//           WEB_SER.api_GET(task: API_DOC.blockUnblockUser, param: param) { (json, data) in
//
//               if json == nil || data == nil {
//                   completion(nil, APP_LBL.something_went_wrong)
//                   return
//               } else {
//
//                   let arrMod = try! self.decoder.decode([GeneralTripCodeModel].self, from: data!)
//
//                   if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                       
//                       if mod.code == 1 {
//                           completion(mod, nil)
//                       }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                           completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                       } else{
//                           completion(nil, self.getMessage(json: json))
//                       }
//                       
//                   } else {
//                       completion(nil, APP_LBL.something_went_wrong)
//                   }
//               }
//           }
//       }
//    
//    //MARK:- Notification Setting
//
//    func shownotificationsetting(param: [String : String], completion: @escaping (SettingModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.shownotificationsetting, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([SettingModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Update Notification Setting
//
//    func setnotificationsetting(param: [String : String], completion: @escaping (SettingModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.setnotificationsetting, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([SettingModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == 1 {
//                        completion(mod, nil)
//                    } else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                        completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                    
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Chat API
//    
//    func chatlist(param: [String : String], completion: @escaping (ConversationModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.chatlist, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([ConversationModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == 0 {
//                        completion(mod, APP_LBL.api_No_data_found)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                 
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    func chatdetails(param: [String : String], completion: @escaping (ChatMessageModel?, String?) -> ()) {
//
//        WEB_SER.api_GET(task: API_DOC.chatdetails, param: param) { (json, data) in
//
//            if json == nil || data == nil {
//                completion(nil, APP_LBL.something_went_wrong)
//                return
//            } else {
//
//                let arrMod = try! self.decoder.decode([ChatMessageModel].self, from: data!)
//
//                if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                    
//                    if mod.code == ResponseCodeType.success.rawValue {
//                        completion(mod, nil)
//                    } else if mod.code == 0 {
//                        completion(mod, APP_LBL.api_No_data_found)
//                    } else {
//                        completion(nil, self.getMessage(json: json))
//                    }
//                 
//                } else {
//                    completion(nil, APP_LBL.something_went_wrong)
//                }
//            }
//        }
//    }
//    
//    //MARK:- Conversation Delete
//
//    func callDeleteConversation(param: [String : String], completion: @escaping (GeneralTripCodeModel?, String?) -> ()) {
//
//          WEB_SER.api_POST(task: API_DOC.deleteChat, param: param) { (json, data) in
//
//              if json == nil || data == nil {
//                  completion(nil, APP_LBL.something_went_wrong)
//                  return
//              } else {
//
//                  let arrMod = try! self.decoder.decode([GeneralTripCodeModel].self, from: data!)
//
//                  if arrMod.count > 0, let mod = arrMod.first, self.validateResCode(code: mod.code) {
//                      
//                      if mod.code == 1 {
//                          completion(mod, nil)
//                      }else if mod.code == ResponseCodeType.accountInactive.rawValue {
//                          completion(nil, APP_LBL.your_account_inactive_please_contact_to_administrator)
//                      } else{
//                          completion(nil, self.getMessage(json: json))
//                      }
//                      
//                  } else {
//                      completion(nil, APP_LBL.something_went_wrong)
//                  }
//              }
//          }
//      }
    
    

}
