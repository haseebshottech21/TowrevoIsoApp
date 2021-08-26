//
//  WebService.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import Foundation
import Alamofire


let WEB_SER = WEB_HELPER.shared

class WEB_HELPER
{
    private init() { }
    static let shared = WEB_HELPER()
    
    
//    private let BUNDLE_DEVELOPMENT_IDENTIFIRE : String = "com.vrinsoftdev.rentz"
//    private let BUNDLE_LIVE_IDENTIFIRE : String = "com.vrinsoftlive.rentz"
    
    func isDebug() -> Bool
    {
//        if Bundle.main.bundleIdentifier == BUNDLE_LIVE_IDENTIFIRE {
//
//            return false;
//        }
        return true;
    }
    

    
    private func getBaseUrl() -> String
    {
        return "http://towrevo.vrinsoft.in/api/";
    //    return "http://52.62.246.144/public/api/";
    }
    
    
    
    private func getHeader() -> HTTPHeaders
    {
        let header = HTTPHeaders(["Content-Type" : "application/x-www-form-urlencoded","Accept": "/" ])
        return header;
    }
    
    private func getDefaultParam(param: [String : String]) -> [String : String]
    {

        var newParam = param
        
        newParam["is_phone"] = "1";
        //newParam["device_id"] = UUID().uuidString;
        newParam["device_token"] = APP_DEL.deviceToken
        newParam["fcm_token"] = APP_DEL.fcmToken
        newParam["timestamp"] = "\(Int(TimeInterval(Date().timeIntervalSince1970)))"
        
        if APP_DEL.isLoggedInUserFound()
        {
            newParam["token"] = APP_DEL.currentUser?.token ?? ""
        }
        
        return newParam;
    }
    
    
    
    
    
    
    
    
    
    
    //MARK:- GET SERVICE
    
    func api_GET(task: String, param: [String : String], encodingType: URLEncodedFormParameterEncoder.Destination = .methodDependent, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void)
    {
        let passParam = self.getDefaultParam(param: param)
        
        if self.isDebug() {
            print("URL:- ",self.getBaseUrl() + task);
            print("HEADER:- ",self.getHeader())
            print("PARAM:- ",passParam)
        }
        
        AF.request(URL(string: self.getBaseUrl() + task)!, method: .get, parameters: passParam, encoder: URLEncodedFormParameterEncoder(destination: encodingType), headers: self.getHeader(), interceptor: nil).responseJSON { response in
            print("RESPONSE URL:- ",response.request?.url ?? "-")

            switch response.result {
                
            case .success:
                
                print("RESPONSE URL:- ",response.request?.url ?? "-")
                print("RESPONSE:- ",response.value as AnyObject)
    
                completion(response.value as AnyObject, response.data)
                
            case let .failure(error):
                
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(nil, nil)
                return
            }
        }
    }
    
    func api_GET_WithoutBaseUrl(task: String, param: [String : String], encodingType: URLEncodedFormParameterEncoder.Destination = .methodDependent, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void)
    {
        let passParam = self.getDefaultParam(param: param)
        
        if self.isDebug() {
            print("URL:- ",self.getBaseUrl() + task);
            print("HEADER:- ",self.getHeader())
            print("PARAM:- ",passParam)
        }
        
        AF.request(URL(string:  task)!, method: .get, parameters: passParam, encoder: URLEncodedFormParameterEncoder(destination: encodingType), headers: self.getHeader(), interceptor: nil).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                print("RESPONSE URL:- ",response.request?.url ?? "-")
                print("RESPONSE:- ",response.value as AnyObject)
    
                completion(response.value as AnyObject, response.data)
                
            case let .failure(error):
                
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(nil, nil)
                return
            }
        }
    }
    
    
    //MARK:- POST SERVICE
    
    func api_POST(task: String, param: [String : String], encodingType: URLEncodedFormParameterEncoder.Destination = .httpBody, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void) {

        let passParam = self.getDefaultParam(param: param)

        if self.isDebug() {
            print("URL:- ",self.getBaseUrl() + task);
            print("HEADER:- ",self.getHeader())
            print("PARAM:- ",passParam)
        }
        
        
        AF.request(URL(string: self.getBaseUrl() + task)!, method: .post, parameters: passParam, encoder: URLEncodedFormParameterEncoder(destination: encodingType), headers: self.getHeader(), interceptor: nil).responseJSON { response in
                
            switch response.result {
                
            case .success:
                
                print("RESPONSE URL:- ",response.request?.url ?? "-")
                print("RESPONSE:- ",response.value as AnyObject)
    
                completion(response.value as AnyObject, response.data)
                
            case let .failure(error):
                
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(nil, nil)
                return
            }
        }

    }
   
    func POST_ArrUploadRequest(task: String, param: [String : String], arrData: NSArray, progressCompletion: @escaping (_ uploadProgress: Double?) -> Void, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void) {

        let passParam = self.getDefaultParam(param: param)

        if self.isDebug() {
            print("URL:- ",self.getBaseUrl() + task)
            print("HEADER:- ",self.getHeader())
            print("PARAM:- ",passParam)
           
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
             let count = arrData.count

                              for i in 0..<count{
                                  let date = Date()
                                  let formatter = DateFormatter()
                                  formatter.dateFormat = "ddMMyyyyhhmmss"
                                  let result: String = formatter.string(from: date)
                                  let strImageName = String(format: "%@\(i).jpeg",result)

                                  let img = Utility.compressImage(sourceImage: arrData[i] as! UIImage)

                                  let imgData = img.jpegData(compressionQuality: 1.0)

                                  multipartFormData.append(imgData!, withName: "image_file[]", fileName: strImageName, mimeType: "image/jpeg")
                              }

            for (key, value) in param {
                                  multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                                 }

            
        }, to: URL(string: self.getBaseUrl() + task)!,
           usingThreshold: UInt64.init(),
           method: .post,
           headers: self.getHeader(),
           interceptor: nil,
           fileManager: FileManager.default)
        
        .uploadProgress { progress in
            print("RESPONSE:- Upload Progress: ",progress.fractionCompleted)
            progressCompletion(progress.fractionCompleted)
        }
        .downloadProgress { progress in
            print("RESPONSE:- Download Progress: ",progress.fractionCompleted)
        }
        .responseJSON { response in
            
            switch response.result {
                        
            case .success:
                
                print("RESPONSE URL:- ",response.request?.url ?? "-")
                print("RESPONSE:- ",response.value as AnyObject)
    
                completion(response.value as AnyObject, response.data)
                
            case let .failure(error):
                
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(nil, nil)
                return
            }
        }
        
    }
    
    func api_POST(task: String, param: [String : String], dictImage: [String : UIImage], progressCompletion: @escaping (_ uploadProgress: Double?) -> Void, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void) {

        let passParam = self.getDefaultParam(param: param)

        if self.isDebug() {
            print("URL:- ",self.getBaseUrl() + task)
            print("HEADER:- ",self.getHeader())
            print("PARAM:- ",passParam)
            print("IMAGE DATA:- ",dictImage)
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in dictImage
            {
                if  let imageData = value.jpegData(compressionQuality: 0.5)
                {
                    let itemName = String(format: "ios\(NSDate().timeIntervalSince1970).jpeg")
                    multipartFormData.append(imageData, withName: key, fileName: itemName, mimeType: "image/jpeg")
                }
            }
            
            for (key, value) in param
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: URL(string: self.getBaseUrl() + task)!,
           usingThreshold: UInt64.init(),
           method: .post,
           headers: self.getHeader(),
           interceptor: nil,
           fileManager: FileManager.default)
        
        .uploadProgress { progress in
            print("RESPONSE:- Upload Progress: ",progress.fractionCompleted)
            progressCompletion(progress.fractionCompleted)
        }
        .downloadProgress { progress in
            print("RESPONSE:- Download Progress: ",progress.fractionCompleted)
        }
        .responseJSON { response in
            
            switch response.result {
                        
            case .success:
                
                print("RESPONSE URL:- ",response.request?.url ?? "-")
                print("RESPONSE:- ",response.value as AnyObject)
    
                completion(response.value as AnyObject, response.data)
                
            case let .failure(error):
                
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(nil, nil)
                return
            }
        }
        
    }
    
    
    
    
    //MARK:- PUT SERVICE
    
    func api_PUT(task: String, param: [String : String], encodingType: URLEncodedFormParameterEncoder.Destination = .methodDependent, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void) {

        let passParam = self.getDefaultParam(param: param)

        if self.isDebug() {
            print("URL:- ",self.getBaseUrl() + task);
            print("HEADER:- ",self.getHeader())
            print("PARAM:- ",passParam)
        }

        AF.request(URL(string: self.getBaseUrl() + task)!, method: .put, parameters: passParam, encoder: URLEncodedFormParameterEncoder(destination: encodingType), headers: self.getHeader(), interceptor: nil).responseJSON { response in
                    
            switch response.result {
                
            case .success:
                
                print("RESPONSE URL:- ",response.request?.url ?? "-")
                print("RESPONSE:- ",response.value as AnyObject)
    
                completion(response.value as AnyObject, response.data)
                
            case let .failure(error):
                
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(nil, nil)
                return
            }
        }
        
    }
    
    func api_PUT(task: String, param: [String : String], dictImage: [String : UIImage], progressCompletion: @escaping (_ uploadProgress: Double?) -> Void, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void) {

        let passParam = self.getDefaultParam(param: param)

        if self.isDebug() {
            print("URL:- ",self.getBaseUrl() + task);
            print("HEADER:- ",self.getHeader())
            print("PARAM:- ",passParam)
            print("IMAGE DATA:- ",dictImage)
        }

        AF.upload(multipartFormData: { (multipartFormData) in
                
            for (key, value) in dictImage
            {
                if  let imageData = value.jpegData(compressionQuality: 0.5)
                {
                    let itemName = String(format: "ios\(NSDate().timeIntervalSince1970).jpeg")
                    multipartFormData.append(imageData, withName: key, fileName: itemName, mimeType: "image/jpeg")
                }
            }
            
            for (key, value) in param
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: URL(string: self.getBaseUrl() + task)!,
           usingThreshold: UInt64.init(),
           method: .put,
           headers: self.getHeader(),
           interceptor: nil,
           fileManager: FileManager.default)
        
        .uploadProgress { progress in
            print("RESPONSE:- Upload Progress: ",progress.fractionCompleted)
            progressCompletion(progress.fractionCompleted)
        }
        .downloadProgress { progress in
            print("RESPONSE:- Download Progress: ",progress.fractionCompleted)
        }
        .responseJSON { response in
            
            switch response.result {
                        
            case .success:
                
                print("RESPONSE URL:- ",response.request?.url ?? "-")
                print("RESPONSE:- ",response.value as AnyObject)
    
                completion(response.value as AnyObject, response.data)
                
            case let .failure(error):
                
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(nil, nil)
                return
            }
        }

    }
    
    
    
    
    
    
    //MARK:- DELETE SERVICE
    
    func api_DELETE(task: String, param: [String : String], encodingType: URLEncodedFormParameterEncoder.Destination = .methodDependent, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void) {

        let passParam = self.getDefaultParam(param: param)

        if self.isDebug() {
            print("URL:- ",self.getBaseUrl() + task);
            print("HEADER:- ",self.getHeader())
            print("PARAM:- ",passParam)
        }

        AF.request(URL(string: self.getBaseUrl() + task)!, method: .delete, parameters: passParam, encoder: URLEncodedFormParameterEncoder(destination: encodingType), headers: self.getHeader(), interceptor: nil).responseJSON { response in
                    
            switch response.result {
                
            case .success:
                
                print("RESPONSE URL:- ",response.request?.url ?? "-")
                print("RESPONSE:- ",response.value as AnyObject)
    
                completion(response.value as AnyObject, response.data)
                
            case let .failure(error):
                
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(nil, nil)
                return
            }
        }
        
    }
    
    
//    //MARK:- GET SERVICE GENERAL

//    func api_GET_GENERAL(url: URL, param: [String : String], header: [String : String], encodingType: URLEncodedFormParameterEncoder.Destination = .methodDependent, completion: @escaping (_ json: Any?, _ data: Data?) -> Void) {
//
//        if self.isDebug() {
//            print("URL:- ",url.absoluteString);
//            print("HEADER:- ",self.getHeader())
//            print("PARAM:- ",param)
//        }
//
//        AF.request(url, method: .get, parameters: param, encoder: URLEncodedFormParameterEncoder(destination: encodingType), headers: HTTPHeaders(header), interceptor: nil).responseJSON { response in
//
//            switch response.result {
//
//            case .success:
//
//                print("RESPONSE URL:- ",response.request?.url ?? "-")
//                print("RESPONSE:- ",response.value as AnyObject)
//
//                completion(response.value as AnyObject, response.data)
//
//            case let .failure(error):
//
//                print("Error while fetching remote rooms: \(String(describing: error))")
//                completion(nil, nil)
//                return
//            }
//        }
//
//    }
}





extension Array {
    
    func getData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension Dictionary {
    
    func getData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension NSDictionary {
    
    func getData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [])
    }
}
