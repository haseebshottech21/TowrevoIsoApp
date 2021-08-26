//
//  InquiryPhotos.swift
//  SourceCode
//
//  Created by Yesha on 22/01/21.
//  Copyright © 2021 Technology. All rights reserved.
//

import Foundation
struct Inquiryimage : Codable {
    
    let imgUrl : String!
   
    //let call
    
    enum CodingKeys: String, CodingKey {

        case imgUrl = "imgUrl"

    }
}
