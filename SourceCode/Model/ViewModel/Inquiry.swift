//
//  inquiry.swift
//  SourceCode
//
//  Created by Yesha on 18/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import Foundation
struct InquiryItem : Codable {
    
    let imgUrl : String?
    let title : String?
    let date : String?
    var arrImage : [Inquiryimage]?
    let email : String?
    let mobile : String?
    let discription : String?
    
    //let call
    
    enum CodingKeys: String, CodingKey {

        case imgUrl = "imgUrl"
        case title = "title"
        case date = "date"
        case arrImage = "arrImage"
        case email = "email"
        case mobile = "mobile"
        case discription = "discription"

    }
}
