//
//  GMSHelper.swift
//  PetPack
//
//  Created by vishal.n on 19/05/20.
//  Copyright © 2020 Pratima. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire

let GMS = GMSHelper.shared

class GMSHelper: NSObject {

    private let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    private let baseURLGeocodeSearch = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
    private let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    private let baseURLPlaceDetail = "https://maps.googleapis.com/maps/api/place/details/json?"

    fileprivate var currentVC: UIViewController?
    
    
    static let shared: GMSHelper = {
        
        let instance = GMSHelper()
        return instance
    }()
    

    override init() {
        super.init()
        
        
    }
    
    func getAddress(isForID: Bool = true, location: CLLocationCoordinate2D? = nil, completion: @escaping (Address?, String?) -> ()) {
                
        var passLoc = CLLocationCoordinate2D(latitude: LOCATION.latitude ?? 0.0, longitude: LOCATION.longitude ?? 0.0)
        
        if location != nil {
            passLoc = location!
        }
        
        self.getGeocodeAddress(location: passLoc) { (geocodeMod, err) in
            
            if err == nil {
                
                let add = geocodeMod?.results?.first?.getAddress()
                
                let addr = Address()
                addr.isCurrentLoc = true
                addr.lat = add?.latitude ?? ""
                addr.long = add?.longitude ?? ""
                addr.street = add?.street_number ?? ""
                addr.block = add?.block ?? ""
                addr.society = add?.socity_area ?? ""
                addr.postal_code = add?.postal_code ?? ""
                addr.city = add?.city ?? ""
                addr.address = add?.address ?? ""
                
                completion(addr, nil)
                
            } else {
                
                completion(nil, "Not found valid address. please try again")
            }
        }
    }


    func getGeocodeAddress(location: CLLocationCoordinate2D, completion: @escaping (GeocodeJsonModel?, String?) -> ()) {

        let geocodeURLString = (baseURLGeocode + "latlng=" + "\(String(format: "%.6f", location.latitude)),\(String(format: "%.6f", location.longitude))" + "&key=" + GMSServicesApiKey)

        print("geocodeURLString:- ", geocodeURLString)
        self.getGeocoder(geocodeURL: geocodeURLString) { (mod, err) in
            completion(mod, err)
        }
    }
    
    func getGeocodeAddress(address: String, completion: @escaping (GeocodeJsonModel?, String?) -> ()) {
        
        if address != "" {
                        
            let geocodeURLString = baseURLGeocode + "address=" + address + "&key=" + GMSServicesApiKey
            
            print("geocodeURLString:- ", geocodeURLString)
            self.getGeocoder(geocodeURL: geocodeURLString) { (mod, err) in
                completion(mod, err)
            }

        } else {

            completion(nil, "No valid address.")
        }
    }
    
    func getGeocodePlaceDetail(place_id: String, completion: @escaping (GeocodeJsonPlaceDetailModel?, String?) -> ()) {
        
        var geocodeURLString = (baseURLPlaceDetail + "place_id=" + place_id + "&key=" + GMSServicesApiKey)
        
        print("geocodeURLString:- ", geocodeURLString)
        guard let tempGeocodeURLString = geocodeURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) else {
            
            completion(nil, "Not valid url.")
            return;
        }
        geocodeURLString = tempGeocodeURLString
        
        guard let geocodeURL = URL(string: geocodeURLString) else {
            
            completion(nil, "Not valid url.")
            return;
        }
        
        AF.request(geocodeURL).responseData { (response) in
            
            var err: String?
            var tempDictionary : GeocodeJsonPlaceDetailModel?
            do {

                tempDictionary = try JSONDecoder().decode(GeocodeJsonPlaceDetailModel.self, from: response.data!)
            } catch {
                err = error.localizedDescription
            }
            
            guard let dictionary = tempDictionary else {
                completion(nil, err)
                return;
            }
            
            
            if (err != nil) {
                
                completion(nil, err)
                
            } else {
                
                // Get the response status.
                let status = dictionary.status ?? ""
                
                if status == "OK" {
                    completion(dictionary, nil)
                } else {
                    completion(nil, status)
                }
            }
        }
    }
    
    func getGeocodeTextQuery(searchText: String, completion: @escaping (SearchQueryModel?, String?) -> ()) {
        
        if searchText != "" {
                        
            //SearchQueryModel
            var geocodeURLString = baseURLGeocodeSearch + "query=" + searchText + "&key=" + GMSServicesApiKey + "&inputtype=" + "textquery" + "&fields=" + "formatted_address,name,geometry"

            print("geocodeURLString:- ", geocodeURLString)

            guard let tempGeocodeURLString = geocodeURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) else {

                completion(nil, "Not valid url.")
                return;
            }
            geocodeURLString = tempGeocodeURLString

            guard let geocodeURL = URL(string: geocodeURLString) else {

                completion(nil, "Not valid url.")
                return;
            }

            AF.request(geocodeURL).responseData { (response) in
                
                var err: String?
                var tempDictionary : SearchQueryModel?
                do {
                    
                    tempDictionary = try JSONDecoder().decode(SearchQueryModel.self, from: response.data!)

                } catch {
                    err = error.localizedDescription
                }

                guard let dictionary = tempDictionary else {
                    completion(nil, err)
                    return;
                }


                if (err != nil) {

                    completion(nil, err)

                } else {

                    // Get the response status.
                    let status = dictionary.status ?? ""
                    
                    if status == "OK" {
                        completion(dictionary, nil)
                    } else {
                        completion(nil, status)
                    }
                }
            }

        } else {

            completion(nil, "No valid address.")
        }
    }
    
    private func getGeocoder(geocodeURL: String, completion: @escaping (GeocodeJsonModel?, String?) -> ()) {
        
        var geocodeURLString = geocodeURL
        guard let tempGeocodeURLString = geocodeURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) else {

            completion(nil, "Not valid url.")
            return;
        }
        geocodeURLString = tempGeocodeURLString
        
        print("geocodeURLString:- ", geocodeURLString)

        guard let geocodeURL = URL(string: geocodeURLString) else {

            completion(nil, "Not valid url.")
            return;
        }

        AF.request(geocodeURL).responseData { (response) in
            
            var err: String?
            var tempDictionary : GeocodeJsonModel?
            do {
                
                tempDictionary = try JSONDecoder().decode(GeocodeJsonModel.self, from: response.data!)

            } catch {
                err = error.localizedDescription
            }

            guard let dictionary = tempDictionary else {
                completion(nil, err)
                return;
            }


            if (err != nil) {

                completion(nil, err)

            } else {

                // Get the response status.
                let status = dictionary.status ?? ""

                if status == "OK" {
                    completion(dictionary, nil)
                } else {
                    completion(nil, status)
                }
            }
        }
    }

    
    
    func getDirections(origin: String, destination: String,travelMode: TravelModes, completion: @escaping (DirectionModel?, DistanceDurationMpdel?, String?) -> ()) {

        //DirectionModel
        if origin != "" {

            if destination != "" {

                var directionsURLString = baseURLDirections + "origin=" + origin + "&destination=" + destination + "&key=" + GMSServicesApiKey

                //MARK:- Add waypoints
//                if waypoints.count > 0 {
//
//                    directionsURLString += "&waypoints=optimize:true"
//
//                    for waypoint in waypoints {
//
//                        directionsURLString += "|" + waypoint
//                    }
//                }


                //MARK:- Add travel mode type
                directionsURLString += "&mode=" + (travelMode.rawValue)



                guard let tempDirectionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) else {

                    completion(nil, nil, "Not valid url.")
                    return;
                }
                directionsURLString = tempDirectionsURLString

                guard let directionsURL = URL(string: directionsURLString) else {

                    completion(nil, nil, "Not valid url.")
                    return;
                }
                
                print("geocodeURLString:- ", directionsURL.absoluteString)

                AF.request(directionsURL).responseData { (response) in
                    
                    var err: String?
                    var tempDictionary : DirectionModel?
                    do {

                        tempDictionary = try JSONDecoder().decode(DirectionModel.self, from: response.data!)

                    } catch {
                        err = error.localizedDescription
                    }

                    guard let dictionary = tempDictionary else {
                        completion(nil, nil, err)
                        return;
                    }


                    if (err != nil) {

                        completion(nil, nil, err)

                    } else {

                        // Get the response status.
                        let status = dictionary.status ?? ""

                        if status == "OK" {

                            let ditDur = self.calculateTotalDistanceAndDuration(legs: dictionary.routes?[0].legs ?? [])
                            completion(dictionary, ditDur, nil)
                        } else {
                            completion(nil, nil, status)
                        }
                    }
                }

            } else {
                completion(nil, nil, "Destination is nil.")
            }

        } else {
            completion(nil, nil, "Origin is nil")
        }
    }

    func calculateTotalDistanceAndDuration(legs: [Legs]) -> DistanceDurationMpdel {

        var totalDistanceInMeters = 0
        var totalDurationInSeconds = 0

        for leg in legs {
            totalDistanceInMeters += (leg.distance?.value ?? 0)
            totalDurationInSeconds += (leg.duration?.value ?? 0)
        }

        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)


        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60


        return DistanceDurationMpdel(day: days, hours: remainingHours, minute: remainingMins, seconds: remainingSecs, distance_km: distanceInKilometers, distance_meter: Double(totalDistanceInMeters))
    }
}




