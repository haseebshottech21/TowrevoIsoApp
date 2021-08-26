//
//  CmsModel.swift
//  Monuments
//
//  Created by jayesh.d on 12/11/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import Foundation

struct CmsModel : Codable {
    let code : Int?
    let message : String?
    let data : [Cms]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case data = "data"
    }

  
}

struct Cms : Codable {
    let title : String?
    let description : String?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case description = "description"
    }

}
