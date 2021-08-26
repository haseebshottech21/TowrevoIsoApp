//
//  CmsModel.swift
//  Monuments
//
//  Created by jayesh.d on 12/11/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import Foundation

struct PhotosModel: Codable
{
    let code: Int
    let message: String
    let result: [PhotosListModel]?
    
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case message = "message"
        case result = "result"
    }
}

struct PhotosListModel: Codable
{
    let title: String?
    let id: String?
    let image_url: String?
    let caption: String?
    let date: String?
   
    enum CodingKeys: String, CodingKey {
        
        case title = "title"
        case id = "id"
        case image_url = "image_url"
        case caption = "caption"
        case date = "date"
    }
}
