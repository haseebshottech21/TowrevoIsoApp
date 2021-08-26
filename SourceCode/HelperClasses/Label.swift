//
//  Label.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit



class LabelModel: Codable
{
    let code: Int
    let message: String
    let result: [Label]?
    
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case message = "message"
        case result = "result"
    }
}

struct Label : Codable {
    
    let id : String?
    let labelname : String?
    let labelvalues : String?
    let create_date : String?
    let update_date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case labelname = "labelname"
        case labelvalues = "labelvalues"
        case create_date = "create_date"
        case update_date = "update_date"
    }
}



let APP_LBL = AppLabel.shared
class AppLabel
{
    private init() { }
    static let shared = AppLabel()
    
    // lazy var AlertTitel : String = { return APP_LANG.retrive(label: "tappoo") }()
    
    //MARK:- TXT Placeholder
    func getPlaceholder(type: FormType) -> String {
        
        //APP_LANG.retrive(label: "email")
        
        if type == .Email {
            return APP_LANG.retrive(label: "email")
        } else if type == .CurrentPassword {
            return APP_LANG.retrive(label: "current_password")
        } else if type == .NewPassword {
            return APP_LANG.retrive(label: "new_password")
        } else if type == .Password {
            return APP_LANG.retrive(label: "password")
        } else if type == .Confirm_password {
            return APP_LANG.retrive(label: "confirm_password")
        } else if type == .Full_name {
            return APP_LANG.retrive(label: "full_name")
        } else if type == .FirstName {
            return APP_LANG.retrive(label: "first_name")
        } else if type == .LastName {
            return APP_LANG.retrive(label: "last_name")
        } else if type == .date_of_birth {
            return APP_LANG.retrive(label: "date_of_birth")
        } else {
            return APP_LANG.retrive(label: "" )
        }
    }
    
    //MARK:- API Labels
    
    lazy var AlertTitel : String = { return APP_LANG.retrive(label: "AlertTitel") }()
    
    lazy var Email_sent_successfully : String = { return APP_LANG.retrive(label: "Email_sent_successfully") }()
    
    lazy var No_email_address_found_in_system : String = { return APP_LANG.retrive(label: "No_email_address_found_in_system") }()
    
    lazy var Cannot_connect_to_server : String = { return APP_LANG.retrive(label: "Cannot_connect_to_server") }()
    
    lazy var No_such_user_exist : String = { return APP_LANG.retrive(label: "No_such_user_exist") }()
    
    lazy var user_not_found : String = { return APP_LANG.retrive(label: "user_not_found") }()
    
    lazy var Invalid_token : String = { return APP_LANG.retrive(label: "Invalid_token") }()
    lazy var email_already_exist : String = { return APP_LANG.retrive(label: "email_already_exist") }()
    lazy var No_Records_Found : String = { return APP_LANG.retrive(label: "No_Records_Found") }()
    
    lazy var You_have_successfully_changed_the_password : String = { return APP_LANG.retrive(label: "You_have_successfully_changed_the_password") }()
    
    lazy var Fail_to_update_password : String = { return APP_LANG.retrive(label: "Fail_to_update_password") }()
    
    lazy var Current_Password_does_not_match : String = { return APP_LANG.retrive(label: "Current_Password_does_not_match") }()
    
    lazy var No_Modified_Records_Found : String = { return APP_LANG.retrive(label: "No_Modified_Records_Found") }()
    
    lazy var No_Such_Task_Assigned : String = { return APP_LANG.retrive(label: "No_Such_Task_Assigned") }()
    
    lazy var You_have_not_Checked_In : String = { return APP_LANG.retrive(label: "You_have_not_Checked_In") }()
    
    lazy var Invalide_Parameter_value : String = { return APP_LANG.retrive(label: "Invalide_Parameter_value") }()
    
    lazy var Fail_to_update_profile : String = { return APP_LANG.retrive(label: "Fail_to_update_profile") }()
    
    lazy var profile_successfully_updated : String = { return APP_LANG.retrive(label: "profile_successfully_updated") }()
    
    lazy var thanks_for_sharing_your_experience_with_us : String = { return APP_LANG.retrive(label: "thanks_for_sharing_your_experience_with_us") }()
    
    lazy var Please_select_start_date : String = { return APP_LANG.retrive(label: "please_select_start_date") }()
    
    lazy var let_socialbug_access_your_location : String = { return APP_LANG.retrive(label: "let_socialbug_access_your_location") }()
    
    lazy var enable_location : String = { return APP_LANG.retrive(label: "enable_location") }()
    
    lazy var allow_permission : String = { return APP_LANG.retrive(label: "allow_permission") }()
    
    lazy var not_now : String = { return APP_LANG.retrive(label: "not_now") }()
    
    lazy var something_went_wrong : String = { return APP_LANG.retrive(label: "something_went_wrong") }()
    
    lazy var has_been_blocked : String = { return APP_LANG.retrive(label: "has_been_blocked") }()
    
    lazy var trip_must_contain_atleast_two_place : String = { return APP_LANG.retrive(label: "trip_must_contain_atleast_two_place") }()
    
    lazy var trip_place_maximum_value_reached : String = { return APP_LANG.retrive(label: "trip_place_maximum_value_reached") }()
    
    lazy var No_data_found : String = { return APP_LANG.retrive(label: "No_data_found") }()
    
    lazy var api_Cannot_connect_to_server : String = { return APP_LANG.retrive(label: "api_Cannot_connect_to_server") }()
    
    lazy var api_email_already_exists_with_another_account_please_try_with_another_one : String = { return APP_LANG.retrive(label: "api_email_already_exists_with_another_account_please_try_with_another_one") }()
    
    lazy var Invalid_username_or_password : String = { return APP_LANG.retrive(label: "Invalid_username_or_password") }()
    
    lazy var Invalid_OTP : String = { return APP_LANG.retrive(label: "Invalid_OTP") }()
    
    lazy var Invalid_email_or_password : String = { return APP_LANG.retrive(label: "Invalid_email_or_password") }()
    
    lazy var your_account_inactive_please_contact_to_administrator : String = { return APP_LANG.retrive(label: "your_account_inactive_please_contact_to_administrator") }()
    
    lazy var review_already_added_for_this_place : String = { return APP_LANG.retrive(label: "review_already_added_for_this_place") }()
    
    lazy var alert_number_attendes_exceeds : String = { return APP_LANG.retrive(label: "alert_number_attendes_exceeds") }()
    
    lazy var trip_not_available_anymore : String = { return APP_LANG.retrive(label: "trip_not_available_anymore") }()
    lazy var post_not_available_anymore : String = { return APP_LANG.retrive(label: "post_not_available_anymore") }()
    lazy var event_not_available_anymore : String = { return APP_LANG.retrive(label: "event_not_available_anymore") }()
    
    lazy var admin : String = { return APP_LANG.retrive(label: "admin") }()
    
    lazy var email_sent_successfully_please_check_your_email : String = { return APP_LANG.retrive(label: "email_sent_successfully_please_check_your_email") }()
    
    lazy var no_email_found_in_the_system : String = { return APP_LANG.retrive(label: "no_email_found_in_the_system") }()
    lazy var no_mobile_number_found_in_the_system : String = { return APP_LANG.retrive(label: "no_mobile_number_found_in_the_system") }()
    
    lazy var error_while_send_mail : String = { return APP_LANG.retrive(label: "error_while_send_mail") }()
    
    lazy var password_does_not_match : String = { return APP_LANG.retrive(label: "password does not match") }()
    lazy var current_password_is_wrong : String = { return APP_LANG.retrive(label: "current_password_is_wrong") }()
    
    //MARK:- Register
    
    lazy var register_small : String = { return APP_LANG.retrive(label: "register_small")}()
    
    lazy var register_as : String = { return APP_LANG.retrive(label: "register_as")}()
    
    lazy var You_are_registered_successfully : String = { return APP_LANG.retrive(label: "You_are_registered_successfully") }()
    
    lazy var company : String = { return APP_LANG.retrive(label: "company") }()
    
    lazy var user : String = { return APP_LANG.retrive(label: "user") }()
    
    lazy var kindly_select_one_option : String = { return APP_LANG.retrive(label: "kindly_select_one_option")}()
    lazy var user_registration : String = { return APP_LANG.retrive(label: "user_registration")}()
   
    //MARK:- ForgotPassword
    
    lazy var deletails_will_be_sent_to_registered_email_id : String = { return APP_LANG.retrive(label: "deletails_will_be_sent_to_registered_email_id") }()
    
    lazy var enter_your_email_to_reset_password : String = { return APP_LANG.retrive(label: "enter_your_email_to_reset_password") }()
    
    lazy var submit : String = { return APP_LANG.retrive(label: "submit") }()
    
    //MARK:- Change _ Password
    
    lazy var save : String = { return APP_LANG.retrive(label: "Save") }()
    lazy var Currernt_password : String = { return APP_LANG.retrive(label: "Currernt_password") }()
    lazy var New_password : String = { return APP_LANG.retrive(label: "New_password") }()
    lazy var Confirm_password : String = { return APP_LANG.retrive(label: "Confirm_password") }()
    
    lazy var change_password : String = { return APP_LANG.retrive(label: "change_password") }()
    
    lazy var please_enter_current_password : String = { return APP_LANG.retrive(label: "please_enter_current_password") }()
    
    lazy var password_successfully_changed : String = { return APP_LANG.retrive(label: "password_successfully_changed") }()
    
    lazy var Please_enter_Password : String = { return APP_LANG.retrive(label: "Please_enter_Password") }()
    
    lazy var Please_enter_Confirm_Password : String = { return APP_LANG.retrive(label: "Please_enter_Confirm_Password") }()
    lazy var password_length_must_be_4_letter : String = { return APP_LANG.retrive(label: "password_length_must_be_4_letter") }()
    
    
    lazy var Password_not_matched : String = { return APP_LANG.retrive(label: "Password_not_matched") }()
    
    lazy var No_Comments_yet : String = { return APP_LANG.retrive(label: "No_Comments_yet") }()
    lazy var Write_your_comment : String = { return APP_LANG.retrive(label: "Write_your_comment") }()
    
    lazy var lbl_available_parking : String = { return APP_LANG.retrive(label: "lbl_available_parking") }()
    lazy var normal_parking : String = { return APP_LANG.retrive(label: "normal_parking") }()
    lazy var premium_parking : String = { return APP_LANG.retrive(label: "premium_parking") }()
    lazy var event_successfully_deleted : String = { return APP_LANG.retrive(label: "event_successfully_deleted") }()
    
    lazy var event_not_found : String = { return APP_LANG.retrive(label: "event_not_found") }()
    lazy var group_not_found : String = { return APP_LANG.retrive(label: "group_not_found") }()
    
    
    lazy var no_attendees_available : String = { return  APP_LANG.retrive(label: "no_attendees_available" )}()
    
    lazy var members : String = { return APP_LANG.retrive(label: "memberS")  }()
    
    lazy var group_is_private_follow_to_see_members : String = { return APP_LANG.retrive(label: "group_is_private_follow_to_see_members")  }()
    
    
    //Remain to add in admin
    lazy var created_on : String = { return APP_LANG.retrive(label: "created") }()
    lazy var Private : String = { return APP_LANG.retrive(label: "Private") }()
    lazy var Public : String = { return APP_LANG.retrive(label: "Public") }()
    
    //MARK:- Login
    
    lazy var email_address : String = { return APP_LANG.retrive(label: "email_address") }()
    lazy var password : String = {return APP_LANG.retrive(label: "password")}()
    lazy var login : String = { return APP_LANG.retrive(label: "login") }()
    lazy var register : String = { return APP_LANG.retrive(label: "register")}()
    lazy var please_enter_valid_Email : String = { return APP_LANG.retrive(label: "please_enter_valid_Email") }()
    lazy var please_enter_valid_password : String = { return APP_LANG.retrive(label: "please_enter_valid_password") }()
    lazy var you_are_successfully_logged_in : String = { return APP_LANG.retrive(label: "you_are_successfully_logged_in") }()
    lazy var forgot_password_question : String = { return APP_LANG.retrive(label: "forgot_password_question")  }()
    lazy var dont_have_an_account : String = { return APP_LANG.retrive(label: "dont_have_an_account") }()
    lazy var please_enter_email : String = {return APP_LANG.retrive(label: "please_enter_email") }()
    lazy var please_enter_password : String = { return APP_LANG.retrive(label: "please_enter_password") }()
    
    //MARK:- company register
    
    lazy var company_register : String = { return APP_LANG.retrive(label: "company_register")}()
    lazy var login_capital : String = { return APP_LANG.retrive(label: "login_capital")}()
    lazy var already_have_an_account : String = { return APP_LANG.retrive(label: "already_have_an_account")}()
    lazy var address_colon : String = { return APP_LANG.retrive(label: "address_colon")}()
    lazy var working_hours_colon : String = { return APP_LANG.retrive(label: "working_hours_colon")}()
    lazy var about_colon : String = { return APP_LANG.retrive(label: "about_colon")}()
    lazy var please_enter_about : String = { return APP_LANG.retrive(label: "please_enter_about")}()
    lazy var please_select_category : String = { return APP_LANG.retrive(label: "please_select_category")}()
    lazy var please_enter_hours : String = { return APP_LANG.retrive(label: "please_enter_hours")}()
    lazy var please_enter_address : String = { return APP_LANG.retrive(label: "please_enter_address")}()
    lazy var please_enter_valid_mobile_number : String = { return APP_LANG.retrive(label: "please_enter_valid_mobile_number")}()
    lazy var first_name : String = { return APP_LANG.retrive(label: "first_name")}()
    lazy var last_name : String = { return APP_LANG.retrive(label: "last_name")}()
    lazy var company_name_colon : String = { return APP_LANG.retrive(label: "company_name_colon")}()
    lazy var mobile_number_colon : String = { return APP_LANG.retrive(label: "mobile_number_colon")}()
    lazy var message_colon : String = { return APP_LANG.retrive(label: "message_colon")}()
    lazy var Customer_Details : String = { return APP_LANG.retrive(label: "Customer_Details" )}()
    lazy var old_password_colon : String = { return APP_LANG.retrive(label: "old_password_colon")}()
    lazy var new_password_colon : String = { return APP_LANG.retrive(label: "new_password_colon")}()
    lazy var confirm_password_colon : String = { return APP_LANG.retrive(label: "confirm_password_colon")}()
    lazy var images : String = { return APP_LANG.retrive(label: "images")}()
    lazy var about : String = { return APP_LANG.retrive(label: "about")}()
    lazy var contact : String = { return APP_LANG.retrive(label: "contact")}()
    lazy var update : String = { return APP_LANG.retrive(label: "update")}()
    lazy var no_data_available_at_selected_location : String = { return APP_LANG.retrive(label: "no_data_available_at_selected_location")}()
    
    
    lazy var please_enter_first_name : String = { return APP_LANG.retrive(label: "please_enter_first_name")}()
    lazy var please_enter_last_name : String = { return APP_LANG.retrive(label: "please_enter_last_name")}()
    lazy var please_enter_mobile_number : String = { return APP_LANG.retrive(label: "please_enter_mobile_number")}()
    lazy var please_enter_name : String = { return APP_LANG.retrive(label: "please_enter_name")}()
    lazy var forgot_password : String = { return APP_LANG.retrive(label: "forgot_password")}()
     lazy var edit : String = { return APP_LANG.retrive(label: "edit")}()
    lazy var delete : String = { return APP_LANG.retrive(label: "delete")}()
    lazy var ok : String = { return APP_LANG.retrive(label: "ok")}()
    lazy var cancel : String = { return APP_LANG.retrive(label: "cancel")}()
    lazy var done : String = { return APP_LANG.retrive(label: "done")}()
    lazy var select_category : String = { return APP_LANG.retrive(label: "select_category")}()
    
    //MARK:- forgot Password
    lazy var please_enter_your_email_address_to_reset_your_password : String = { return APP_LANG.retrive(label: "please_enter_your_email_address_to_reset_your_password") }()
    lazy var forget_password_discription : String = { return APP_LANG.retrive(label: "forget_password_discription") }()
    lazy var send : String = { return APP_LANG.retrive(label: "send") }()
    
    
    //MARK:- Otp Verification
    lazy var otp_verificaton : String = { return APP_LANG.retrive(label: "otp_verificaton") }()
    lazy var we_have_sent_you_an_sms_with_a_code : String = { return APP_LANG.retrive(label: "we_have_sent_you_an_sms_with_a_code") }()
    lazy var expiring_in : String = { return APP_LANG.retrive(label: "expiring_in") }()
    lazy var verify : String = { return APP_LANG.retrive(label: "verify") }()
    lazy var re_send_code : String = { return APP_LANG.retrive(label: "re_send_code") }()
    lazy var please_enter_otp : String = { return APP_LANG.retrive(label: "please_enter_otp") }()
    
    //MARK:- CreateNewPassword
    lazy var create_new_password : String = { return APP_LANG.retrive(label: "create_new_password") }()
    lazy var reset : String = { return APP_LANG.retrive(label: "reset") }()
    lazy var please_enter_new_password : String = { return APP_LANG.retrive(label: "please_enter_new_password") }()
    lazy var please_enter_confirm_password : String = { return APP_LANG.retrive(label: "please_enter_confirm_password") }()
    lazy var new_password_and_confirm_password_must_be_same : String = { return APP_LANG.retrive(label: "new_password_and_confirm_password_must_be_same") }()
    lazy var new_password_and_old_password_must_be_different : String = { return APP_LANG.retrive(label: "new_password_and_old_password_must_be_different") }()
    lazy var please_enter_old_password : String = { return APP_LANG.retrive(label: "please_enter_old_password") }()
    
    //MARK:- HomeVC
    lazy var pickup_location : String = { return APP_LANG.retrive(label: "pickup_location") }()
    lazy var select_location : String = { return APP_LANG.retrive(label: "select_location") }()
    lazy var category : String = { return APP_LANG.retrive(label: "category") }()
    lazy var category_colon : String = { return APP_LANG.retrive(label: "category_colon") }()
    lazy var next : String = { return APP_LANG.retrive(label: "Next") }()
    lazy var please_enter_location = { return APP_LANG.retrive(label: "Please Enter Location") }()
    lazy var please_enter_category = { return APP_LANG.retrive(label: "Please Enter Location") }()
    
    //MARK:- Towing Companies
    lazy var towing_companies : String = { return APP_LANG.retrive(label: "towing_companies") }()
    lazy var get_direction : String = { return APP_LANG.retrive(label: "get_direction") }()
    lazy var distance_unit : String = { return APP_LANG.retrive(label: "distance_unit") }()
    
    //MARK:- Towing Service Companies
    lazy var send_enquiry : String = { return APP_LANG.retrive(label: "send_enquiry") }()
    
    //MARK:- Enquiry
    lazy var inquiry_title : String = { return APP_LANG.retrive(label: "inquiry_title") }()
    lazy var attach_image : String = { return APP_LANG.retrive(label: "attach_image") }()
    lazy var please_enter_message : String = { return APP_LANG.retrive(label: "please_enter_message") }()
    lazy var inquiry_sent_successfully : String = { return APP_LANG.retrive(label: "inquiry_sent_successfully") }()
    
    //MARK:- Edit Profile
    lazy var edit_profile : String = { return APP_LANG.retrive(label: "edit_profile") }()
    
    //MARK:- CMS
    lazy var privacy_policy : String = { return APP_LANG.retrive(label: "privacy_policy") }()
    lazy var terms_conditions : String = { return APP_LANG.retrive(label: "terms_conditions") }()
    lazy var about_us : String = { return APP_LANG.retrive(label: "about_us") }()
    
    //MARK:- Menu
       lazy var inquiry_management : String = { return APP_LANG.retrive(label: "inquiry_management") }()
       lazy var about_us_small : String = { return APP_LANG.retrive(label: "about_us_small") }()
       lazy var faq : String = { return APP_LANG.retrive(label: "faq") }()
       lazy var contact_us : String = { return APP_LANG.retrive(label: "contact_us") }()
       lazy var my_inquiries : String = { return APP_LANG.retrive(label: "my_inquiries") }()
    lazy var logout : String = { return APP_LANG.retrive(label: "logout") }()
    lazy var copyright : String = { return APP_LANG.retrive(label: "copyright") }()
    lazy var version : String = { return APP_LANG.retrive(label: "version") }()
     lazy var are_you_sure_you_want_to_logout : String = { return APP_LANG.retrive(label: "are_you_sure_you_want_to_logout") }()
     lazy var yes : String = { return APP_LANG.retrive(label: "yes") }()
     lazy var no : String = { return APP_LANG.retrive(label: "no") }()
    lazy var you_are_successfully_logged_out : String = { return APP_LANG.retrive(label: "you_are_successfully_logged_out") }()
    
    
    
    
    lazy var call_us : String = { return APP_LANG.retrive(label: "call_us") }()
    lazy var mail_us : String = { return APP_LANG.retrive(label: "mail_us") }()
    
    
    
}
