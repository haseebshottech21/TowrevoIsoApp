//
//  DateHelper.swift
//  LEES
//
//  Created by jayesh.d on 18/10/19.
//  Copyright © 2019 Vrinsoft. All rights reserved.
//

import Foundation

let DT = DateHelper.shared
class DateHelper {
    
    private init() { }
    static let shared = DateHelper()
    
    lazy var DF: DateFormatter = {
        
        let DF = DateFormatter()
        DF.calendar = Calendar.current
        DF.timeZone = TimeZone.current
        return DF
    }()
    
    func getStringFromDate(date: Date, formate: String) -> String {
        
        DF.dateFormat = formate
        return DF.string(from: date)
    }
    
    func getDateFromString(strDate: String, formate: String) -> Date {
        
        DF.dateFormat = formate
        if let dateValue = DF.date(from: strDate) {
            return dateValue
        }
        return Date()
    }
    
    func getYYYY(date: Date) -> Int {
        
        DF.dateFormat = "yyyy"
        return (DF.string(from: date) as NSString).integerValue
    }
    
    func getMM(date: Date) -> Int {
        
        DF.dateFormat = "MM"
        return (DF.string(from: date) as NSString).integerValue
    }
    
    func getDD(date: Date) -> Int {
        
        DF.dateFormat = "DD"
        return (DF.string(from: date) as NSString).integerValue
    }
    
    func getDateFromStringWith(strDate: String, currentFormate: String, newFormate: String) -> (date: Date, strDate: String) {
        
        DF.dateFormat = currentFormate
        let dt = DF.date(from: strDate)!
        
        DF.dateFormat = newFormate
        let newStrDate = DF.string(from: dt)
        let newDate = DF.date(from: newStrDate)!
        
        return (date: newDate, strDate: newStrDate)
    }
    
    func getDateRange(from: Date, to: Date) -> [Date] {
        
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    func getTomorrow() -> Date {
        
        var DC = DateComponents()
        DC.setValue(1, for: .day);
        return Calendar.current.date(byAdding: DC, to: Date())!
    }
    
    func getYesterday() -> Date {
        
        var DC = DateComponents()
        DC.setValue(-1, for: .day);
        return Calendar.current.date(byAdding: DC, to: Date())!
    }
    
    //MARK:- Current Date & Time
    func getCurrentDateAndTime() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = NSDate ()
        let strCurrentDate :String = formatter.string(from: currentDate as Date)
        return strCurrentDate
    }
}

extension Date {
    
    func getStringDate(formate: String) -> String {
        
        DT.DF.dateFormat = formate
        return DT.DF.string(from: self)
    }
    
    func getYYYY() -> Int {
        
        DT.DF.dateFormat = "yyyy"
        return (DT.DF.string(from: self) as NSString).integerValue
    }
    
    func getMM() -> Int {
        
        DT.DF.dateFormat = "MM"
        return (DT.DF.string(from: self) as NSString).integerValue
    }
    
    func getDD() -> Int {
        
        DT.DF.dateFormat = "DD"
        return (DT.DF.string(from: self) as NSString).integerValue
    }
    
    func isPastDate() -> Bool {
        
        if self.compare(Date()) == ComparisonResult.orderedAscending {
            return true
        }
        return false
    }
    
    func isToday(formate: String) -> Bool {
        
        let cureDT = DT.getDateFromString(strDate: DT.getStringFromDate(date: Date(), formate: formate), formate: formate)
        if self.compare(cureDT) == ComparisonResult.orderedSame {
            return true
        }
        return false
    }
    
    func isSmallerThen(date: Date) -> Bool {
        
        if self.compare(date) == .orderedAscending {
            return true
        }
        return false
    }
    
    func isBiggerThen(date: Date) -> Bool {
        
        if self.compare(date) == .orderedDescending {
            return true
        }
        return false
    }
    
    func isSameThen(date: Date) -> Bool {
        
        if self.compare(date) == .orderedSame {
            return true
        }
        return false
    }
    
    func getTomorrow() -> Date {
        
        var DC = DateComponents()
        DC.setValue(1, for: .day);
        return Calendar.current.date(byAdding: DC, to: self)!
    }
    
    func getYesterday() -> Date {
        
        var DC = DateComponents()
        DC.setValue(-1, for: .day);
        return Calendar.current.date(byAdding: DC, to: self)!
    }
    
    func getDateByDay(day: Int) -> Date {
        
        var DC = DateComponents()
        DC.setValue(day, for: .day);
        return Calendar.current.date(byAdding: DC, to: Date())!
    }
    

    
    func getOrdinalText() -> String {
        

        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let daySuffix: String

        switch day {
        case 11...13: return "th"
        default:
            switch day % 10 {
            case 1: daySuffix = "st"
            case 2: daySuffix = "nd"
            case 3: daySuffix = "rd"
            default: daySuffix = "th"
            }
        }

        let dateFor = DateFormatter()
        dateFor.dateFormat = "dd'\(daySuffix)' MMMM, yyyy"
        let res = dateFor.string(from: self)
        print("Ordinal:- ",res)
        return res
    }
    

}
