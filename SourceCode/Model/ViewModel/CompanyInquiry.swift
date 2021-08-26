//
//  CompanyInquiry.swift
//  SourceCode
//
//  Created by Yesha on 04/02/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import Foundation
struct CompanyInquiry : Codable {
    
    let imgUrl : String?
    let title : String?
    let date : String?
    let about : String?
    var arrImage : [Inquiryimage]?
    let location : String?
    let mobile : String?
    let email : String?
    
    
    
    //let call
    
    enum CodingKeys: String, CodingKey {

        case imgUrl = "imgUrl"
        case title = "title"
        case date = "date"
        case about = "about"
        case arrImage = "arrImage"
        case location = "location"
        case email = "email"
        case mobile = "mobile"
        

    }
}
