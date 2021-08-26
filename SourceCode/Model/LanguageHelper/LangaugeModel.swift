//
//  LangaugeModel.swift
//  WonderWomen
//
//  Created by jayesh.d on 24/09/19.
//  Copyright © 2019 Vrinsoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Language)
public class Language: NSManagedObject {

}

extension Language {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Language> {
        return NSFetchRequest<Language>(entityName: "Language")
    }
    
    @NSManaged public var key: String?
    @NSManaged public var value: String?
}
