//
//  Function.swift
//  Monuments
//
//  Created by jayesh.d on 21/10/19.
//  Copyright © 2019 jayesh.d. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import QuickLook
import Photos


let APP_FUNC = Function.shared

class Function
{
    public init() { }
    static let shared = Function()
    
    func getFont(for font: FontName, size: CGFloat) -> UIFont
    {
        return UIFont(name: font.rawValue, size: getFontSize(size: size))!
    }

    func getColorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor
    {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }

    func isValidEmail(email: String) -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func isValidPassword(password: String) -> Bool {

        let passwordRegex: String = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,15}$"
        let predicateForPassword: NSPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicateForPassword.evaluate(with: password)
    }

    func isValidContactNumber(number: String) -> Bool {

        if number.count >= 14 {
            return false
        } else if number.count < 10 {
            return false
        } else {
            return true
        }
    }

    func getFontSize(size: CGFloat) -> CGFloat
    {
        var sizeNew = size

        if SCREEN_HEIGHT >= 736 {
            sizeNew = sizeNew + 1.0
        } else if SCREEN_HEIGHT >= 667{
            sizeNew = sizeNew + 0.5
        } else if SCREEN_HEIGHT <= 568 {
            sizeNew = sizeNew + 0.0
        }

        if IS_IPAD {
            sizeNew = sizeNew + 2.5
        }

        return sizeNew
    }

    func GetCountryCallingCode(countryRegionCode:String) -> String? {
        
        let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
        let countryDialingCode = prefixCodes[countryRegionCode]
        return countryDialingCode
        
    }
    func getLocalCountryCode() -> String?
    {
        return (Locale.current as NSLocale).object(forKey: .countryCode) as? String
    }
    
//    func getCountryCodeList() -> [CountryCode] {
//
//        let url = Bundle.main.url(forResource: "CountryCode", withExtension: "json")!
//        do {
//            let jsonData = try Data(contentsOf: url)
//            let arrCountry = try JSONDecoder().decode([CountryCode].self, from: jsonData)
//            return arrCountry
//        }
//        catch {
//            print("Smething went wrong")
//        }
//
//        return []
//    }
    
    func  getAttributedString(string: String,
                              color: UIColor? = nil,
                              backgroundColor: UIColor? = nil,
                              strikethroughStyle: Int? = nil,
                              shadowBlurRadius: Int? = nil,
                              shadowOffset: CGSize? = nil,
                              shadowColor: UIColor? = nil,
                              strokeWidth: Int? = nil,
                              underlineStyle: NSUnderlineStyle? = nil,
                              font: UIFont? = nil) -> NSAttributedString
    {
        var newAttribute : [NSAttributedString.Key : Any]? = [:]

        if font != nil {
            newAttribute?.updateValue(font as Any, forKey: NSAttributedString.Key.font)
        }

        if color != nil {
            newAttribute?.updateValue(color as Any, forKey: NSAttributedString.Key.foregroundColor)
        }
        if strikethroughStyle != nil {
            newAttribute?.updateValue(strikethroughStyle as Any, forKey: NSAttributedString.Key.strikethroughStyle)
        }

        let shadow = NSShadow()
        if shadowBlurRadius != nil {
            shadow.shadowBlurRadius = CGFloat(shadowBlurRadius ?? 0)
        }
        if shadowOffset != nil {
            shadow.shadowOffset = shadowOffset!
        }
        if shadowColor != nil {
            shadow.shadowColor = shadowColor
        }

        newAttribute?.updateValue(shadow, forKey: NSAttributedString.Key.shadow)


        if strokeWidth != nil {
            newAttribute?.updateValue(strokeWidth as Any, forKey: NSAttributedString.Key.strokeWidth)
        }
        if backgroundColor != nil {
            newAttribute?.updateValue(backgroundColor as Any, forKey: NSAttributedString.Key.backgroundColor)
        }
        if underlineStyle != nil {
            newAttribute?.updateValue(underlineStyle!.rawValue, forKey: NSAttributedString.Key.underlineStyle)
        }

        return NSAttributedString(string: string, attributes: newAttribute);
    }

    func formatPoints(num: Double) -> String {

        let thousandNum = num/1000
        let millionNum = num/1000000
        
        if num >= 1000 && num < 1000000 {
            
            if (floor(thousandNum) == thousandNum) {
                return("\(Int(thousandNum))K")
            }
            return("\(thousandNum.roundToPlaces(places: 1))K")
        }
        if num > 1000000 {
            
            if(floor(millionNum) == millionNum) {
                return("\(Int(thousandNum))K")
            }
            return ("\(millionNum.roundToPlaces(places: 1))M")
        }
        else{
            
            if(floor(num) == num) {
                return ("\(Int(num))")
            }
            return ("\(num)")
        }
    }
    
    func getHmsFromCMTime(timeSecond : Int) -> (h: String, m: String, s: String) {
        
        //let timeSecond = Int(CMTimeGetSeconds(cmTime))
        let h = (timeSecond / 3600);
        let m = ((timeSecond % 3600) / 60);
        let s = ((timeSecond % 3600) % 60);
        
        return (h: String(format: "%.02d", h),
                m: String(format: "%.02d", m),
                s: String(format: "%.02d", s))
                //secInt: timeSecond)
    }
    
    
    func getImagesFromPHAsset(assets: [PHAsset]) -> [UIImage] {
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        
        var arrImage : [UIImage] = []
        
        for asset in assets {
            
            manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                arrImage.append(result!)
            })
        }
        
        return arrImage
    }
    
    func getImages(assets : [PHAsset], completion:@escaping ([UIImage]) -> ())
    {
        let group = DispatchGroup()
        var images : [UIImage] = []
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.version = .current
        options.resizeMode = .exact
        
        let manager = PHImageManager.default()
        
        for asset in assets
        {
            let w : CGFloat = CGFloat(asset.pixelWidth)
            let h : CGFloat = CGFloat(asset.pixelHeight)
            
            let size = CGSize(width: w * 0.5, height: h * 0.5)
            
            group.enter()
            manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { (image, info) in
                if let image = image
                {
                    images.append(image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main)
        {
            completion(images)
        }
    }
    
    func formattedNumber(formate: String, number: String) -> String {
        //PASS FORMATE
        //"+X XXX XXX XXXX"
        
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        var result = ""
        
        var index = cleanPhoneNumber.startIndex
        for ch in formate where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }

    
}
