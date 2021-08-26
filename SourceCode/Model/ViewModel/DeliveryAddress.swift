//
//  DeliveryAddress.swift
//  SourceCode
//
//  Created by Yesha on 22/12/20.
//  Copyright © 2020 Technology. All rights reserved.
//

import Foundation
struct DeliveryAddressRecord : Codable {
 
    let home : String?
    let zipcode : String?
    let city : String?
    let address_type : Int?
    let landmark : String?
    let district : String?
    let id : String?
    let name : String?
}


class Address : Codable {

    var isCurrentLoc = false
    var id = ""
    var address = ""
    var lat = ""
    var long = ""
    var block = ""
    var street = ""
    var society = ""
    var city = ""
    var postal_code = ""
    
    
    enum CodingKeys: String, CodingKey {

        case isCurrentLoc = "isCurrentLoc"
        case id = "id"
        case address = "address"
        case lat = "lat"
        case long = "long"
        case block = "block"
        case street = "street"
        case society = "society"
        case city = "city"
        case postal_code = "postal_code"
    }
    
    
    func syncronize() {
        
        do {
            
            let json : [String : Any] = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: []) as! [String : Any]
            APP_UDS.set(json, forKey: APP_CONST.selectedAddress)
            APP_UDS.synchronize()
            
        } catch {
            print("ERROR")
        }
    }
    
    
}


struct AddressCodeModel: Codable
{
    let code: Int
    let message: String
    let data : [Addresslist]?
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case message = "message"
        case data = "data"
    }
}


struct Addresslist : Codable {
    var address_id : String?
    var user_id : String?
    var house : String?
    var landmark : String?
    var city : String?
    var district : String?
    var zipcode : String?
    var address_type : String?
    var latitude : String?
    var longitude : String?
    var is_default : String?
    var address : String?

    enum CodingKeys: String, CodingKey {

        case address_id = "address_id"
        case user_id = "user_id"
        case house = "house"
        case landmark = "landmark"
        case city = "city"
        case district = "district"
        case zipcode = "zipcode"
        case address_type = "address_type"
        case latitude = "latitude"
        case longitude = "longitude"
        case is_default = "is_default"
        case address = "address"
    }


}
