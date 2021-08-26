//
//  GMSModel.swift
//  PetPack
//
//  Created by vishal.n on 19/05/20.
//  Copyright © 2020 Pratima. All rights reserved.
//

import Foundation


//MARK:- PREDEDINED TYPE

enum TravelModes: String {
    
    case driving
    case walking
    case bicycling
}


//MARK:- DistanceDurationMpdel
struct DistanceDurationMpdel : Codable {
    
    let day : Int?
    let hours : Int?
    let minute : Int?
    let seconds : Int?
    let distance_km : Double?
    let distance_meter : Double?
}





//MARK:- GeocodeJsonModel

struct GeocodeJsonModel : Codable {
    
    let plus_code : Plus_code?
    let results : [GeocodeAddress]?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case plus_code = "plus_code"
        case results = "results"
        case status = "status"
    }
}

struct GeocodeJsonPlaceDetailModel : Codable {
    
    let result : GeocodeAddress?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case status = "status"
    }
}

struct Plus_code : Codable {
    
    let compound_code : String?
    let global_code : String?

    enum CodingKeys: String, CodingKey {

        case compound_code = "compound_code"
        case global_code = "global_code"
    }
}

struct GeocodeAddress : Codable {
    
    let address_components : [Address_components]?
    let formatted_address : String?
    let geometry : Geometry?
    let place_id : String?
    let types : [String]?
    let name : String?
    let vicinity : String?

    enum CodingKeys: String, CodingKey {

        case address_components = "address_components"
        case formatted_address = "formatted_address"
        case geometry = "geometry"
        case place_id = "place_id"
        case types = "types"
        case name = "name"
        case vicinity = "vicinity"
    }
}

struct Address_components : Codable {
    
    let long_name : String?
    let short_name : String?
    let types : [String]?

    enum CodingKeys: String, CodingKey {

        case long_name = "long_name"
        case short_name = "short_name"
        case types = "types"
    }
}

struct Geometry : Codable {
    
    let bounds : Bounds?
    let location : Location?
    let location_type : String?
    let viewport : Viewport?

    enum CodingKeys: String, CodingKey {

        case bounds = "bounds"
        case location = "location"
        case location_type = "location_type"
        case viewport = "viewport"
    }
}

struct Bounds : Codable {
    
    let northeast : Location?
    let southwest : Location?

    enum CodingKeys: String, CodingKey {

        case northeast = "northeast"
        case southwest = "southwest"
    }
}

struct Location : Codable {
    
    let lat : Double?
    let lng : Double?

    enum CodingKeys: String, CodingKey {

        case lat = "lat"
        case lng = "lng"
    }
}

struct Viewport : Codable {
    
    let northeast : Location?
    let southwest : Location?

    enum CodingKeys: String, CodingKey {

        case northeast = "northeast"
        case southwest = "southwest"
    }
}




//MARK:- Direction

struct DirectionModel : Codable {
    
    let geocoded_waypoints : [Geocoded_waypoints]?
    let routes : [Routes]?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case geocoded_waypoints = "geocoded_waypoints"
        case routes = "routes"
        case status = "status"
    }
}

struct Geocoded_waypoints : Codable {
    
    let geocoder_status : String?
    let place_id : String?
    let types : [String]?

    enum CodingKeys: String, CodingKey {

        case geocoder_status = "geocoder_status"
        case place_id = "place_id"
        case types = "types"
    }
}

struct Routes : Codable {
    
    let bounds : Bounds?
    let copyrights : String?
    let legs : [Legs]?
    let overview_polyline : Overview_polyline?
    let summary : String?
    let warnings : [String]?
    let waypoint_order : [Int]?

    enum CodingKeys: String, CodingKey {

        case bounds = "bounds"
        case copyrights = "copyrights"
        case legs = "legs"
        case overview_polyline = "overview_polyline"
        case summary = "summary"
        case warnings = "warnings"
        case waypoint_order = "waypoint_order"
    }

}

struct Legs : Codable {
    
    let distance : Distance?
    let duration : Duration?
    let end_address : String?
    let end_location : Location?
    let start_address : String?
    let start_location : Location?
    let steps : [Steps]?
    let traffic_speed_entry : [String]?
    let via_waypoint : [String]?

    enum CodingKeys: String, CodingKey {

        case distance = "distance"
        case duration = "duration"
        case end_address = "end_address"
        case end_location = "end_location"
        case start_address = "start_address"
        case start_location = "start_location"
        case steps = "steps"
        case traffic_speed_entry = "traffic_speed_entry"
        case via_waypoint = "via_waypoint"
    }
}

struct Overview_polyline : Codable {
    
    let points : String?

    enum CodingKeys: String, CodingKey {

        case points = "points"
    }
}

struct Distance : Codable {
    
    let text : String?
    let value : Int?

    enum CodingKeys: String, CodingKey {

        case text = "text"
        case value = "value"
    }
}

struct Duration : Codable {
    
    let text : String?
    let value : Int?

    enum CodingKeys: String, CodingKey {

        case text = "text"
        case value = "value"
    }
}

struct Steps : Codable {
    
    let distance : Distance?
    let duration : Duration?
    let end_location : Location?
    let html_instructions : String?
    let polyline : Polyline?
    let start_location : Location?
    let travel_mode : String?

    enum CodingKeys: String, CodingKey {

        case distance = "distance"
        case duration = "duration"
        case end_location = "end_location"
        case html_instructions = "html_instructions"
        case polyline = "polyline"
        case start_location = "start_location"
        case travel_mode = "travel_mode"
    }
}

struct Polyline : Codable {
    
    let points : String?

    enum CodingKeys: String, CodingKey {

        case points = "points"
    }
}





//MARK:- Search Query
struct SearchQueryModel : Codable {
    
    let html_attributions : [String]?
    let next_page_token : String?
    let results : [SearchQuery]?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case html_attributions = "html_attributions"
        case next_page_token = "next_page_token"
        case results = "results"
        case status = "status"
    }
}

struct SearchQuery : Codable {
    
    let business_status : String?
    let formatted_address : String?
    let geometry : Geometry?
    let icon : String?
    let id : String?
    let name : String?
    let photos : [Photos]?
    let place_id : String?
    let plus_code : Plus_code?
    let rating : Double?
    let reference : String?
    let types : [String]?
    let user_ratings_total : Int?

    enum CodingKeys: String, CodingKey {

        case business_status = "business_status"
        case formatted_address = "formatted_address"
        case geometry = "geometry"
        case icon = "icon"
        case id = "id"
        case name = "name"
        case photos = "photos"
        case place_id = "place_id"
        case plus_code = "plus_code"
        case rating = "rating"
        case reference = "reference"
        case types = "types"
        case user_ratings_total = "user_ratings_total"
    }

}

struct Photos : Codable {
    
    let height : Int?
    let html_attributions : [String]?
    let photo_reference : String?
    let width : Int?

    enum CodingKeys: String, CodingKey {

        case height = "height"
        case html_attributions = "html_attributions"
        case photo_reference = "photo_reference"
        case width = "width"
    }
}




extension GeocodeAddress {
    
    func getAddress() -> (
        street_number: String,
        route: String,
        socity: String,
        socity_area: String,
        city: String,
        block: String,
        state: String,
        country: String,
        postal_code: String,
        latitude: String,
        longitude: String,
        address: String) {
        
        let add_comp = self.address_components ?? []
        let geom = self.geometry
        
        //Street
        var street_number = ""
        let _ = add_comp.first { (com) -> Bool in
            if com.types?.contains("route") ?? false {
                street_number = com.long_name ?? ""
                return true;
            }
            return false
        }
        
        if street_number == "" {
            street_number = self.name ?? ""
        }
            
        if street_number == "" {
            let _ = add_comp.first { (com) -> Bool in
                if com.types?.contains("administrative_area_level_1") ?? false {
                    street_number = com.long_name ?? ""
                    return true;
                }
                return false
            }
        }
        
        
        //Main area/ Road
        var route = ""
        let _ = add_comp.first { (com) -> Bool in
            if com.types?.contains("route") ?? false {
                route = com.short_name ?? ""
                return true;
            }
            return false
        }
        
        //Socity
        var socity = ""
        let _ = add_comp.first { (com) -> Bool in
            if com.types?.contains("sublocality_level_2") ?? false {
                socity = com.short_name ?? ""
                return true;
            }
            return false
        }
        
        //Socity area
        var socity_area = self.vicinity ?? ""
        if socity_area == "" {
            let _ = add_comp.first { (com) -> Bool in
                if (com.types?.contains("sublocality_level_1") ?? false) {
                    socity_area = com.long_name ?? ""
                    return true;
                }
                return false
            }
        }
        
        if socity_area == "" {
            
            let _ = add_comp.first { (com) -> Bool in
                if (com.types?.contains("sublocality") ?? false) {
                    socity_area = com.long_name ?? ""
                    return true;
                }
                return false
            }
        }
        
            
        
        //City
        var city = ""
        let _ = add_comp.first { (com) -> Bool in
            if com.types?.contains("administrative_area_level_2") ?? false {
                city = com.short_name ?? ""
                return true;
            }
            return false
        }
        
        if city == "" {
            
            let _ = add_comp.first { (com) -> Bool in
                if com.types?.contains("locality") ?? false {
                    city = com.short_name ?? ""
                    return true;
                }
                return false
            }
        }
        
        //Block
        var block = ""
        let _ = add_comp.first { (com) -> Bool in
            if com.types?.contains("neighborhood") ?? false {
                block = com.short_name ?? ""
                return true;
            }
            return false
        }
            
            
        //State
        var state = ""
        let _ = add_comp.first { (com) -> Bool in
            if com.types?.contains("administrative_area_level_1") ?? false {
                state = com.short_name ?? ""
                return true;
            }
            return false
        }
        
        //Country
        var country = ""
        let _ = add_comp.first { (com) -> Bool in
            if com.types?.contains("country") ?? false {
                country = com.short_name ?? ""
                return true;
            }
            return false
        }
        
        //Postal Code
        var postal_code = ""
        let _ = add_comp.first { (com) -> Bool in
            if com.types?.contains("postal_code") ?? false {
                postal_code = com.short_name ?? ""
                return true;
            }
            return false
        }
        
        return (
            street_number: street_number,
            route: route,
            socity: socity,
            socity_area: socity_area,
            city: city,
            block: block,
            state: state,
            country: country,
            postal_code: postal_code,
            latitude: "\(geom?.location?.lat ?? 0.0)",
            longitude: "\(geom?.location?.lng ?? 0.0)",
            address: self.formatted_address ?? "")
    }
}
