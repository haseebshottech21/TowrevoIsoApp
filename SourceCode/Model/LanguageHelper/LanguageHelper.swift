//
//  LanguageHelper.swift
//  WonderWomen
//
//  Created by jayesh.d on 24/09/19.
//  Copyright © 2019 Vrinsoft. All rights reserved.
//

import Foundation
import CoreData


struct CD_Key {
    
    static let key : String = "key"
    static let value : String = "value"
}

struct LBL : Codable {
    
    var key: String
    var value: String
    
    init(key: String, value: String)
    {
        self.key = key
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        
        case key = "key"
        case value = "value"
    }
}

let APP_LANG = LanguageHelper.shared
class LanguageHelper {
    
    
    private init() { }
    static let shared = LanguageHelper()
    
    // MARK: - Core Data stack
    private var dbLanguage: NSPersistentContainer = {
        
        let db = NSPersistentContainer(name: "LanguageHelper")
        db.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return db
    }()
    
    private var dbContext: NSManagedObjectContext {
        return dbLanguage.viewContext
    }
    
    
    
    // MARK: - Tabels
    
    private var tblLanguage : NSEntityDescription {
        
        return NSEntityDescription.entity(forEntityName: "Language", in: dbContext)!
    }
    
    
    
    
    // MARK: - Core Data Saving support
    private func saveContext() {
        let context = dbLanguage.viewContext
        if context.hasChanges {
            
            do {
                
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save() {
        self.saveContext()
    }
    
    func manageLabelList(list: [LBL]) {
        
        for lbl in list {
            
            if self.isExist(label: lbl.key) {
                self.update(label: lbl)
            } else {
                self.insert(label: lbl)
            }
        }
    }
    
    
    
    private func insert(label: LBL) {
        let lbl = Language(entity: tblLanguage, insertInto: dbContext)
        lbl.key = label.key
        lbl.value = label.value

        print("CD LANG:- INSERT: \(label.key) => DONE")
        self.saveContext()
    }
    
    private func update(label: LBL) {
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        req.predicate = NSPredicate(format: "\(CD_Key.key) = %@", "\(label.key)")
        
        do {
            let language = try dbContext.fetch(req)
            if language.count > 0 {
                
                let lbl = language[0]
                lbl.value = label.value
                
                print("CD LANG:- UPDATE: \(label.key) => DONE")
                self.saveContext()
            }
        } catch {
            
        }
    }
    
    
    private func isExist(label: String) -> Bool {
        
        var isExist = false
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        req.predicate = NSPredicate(format: "\(CD_Key.key) = %@", "\(label)")
        
        do {
            let language = try dbContext.fetch(req)
            if language.count > 0 {
                isExist = true
            }
        } catch {
            
        }
        return isExist
    }
    
    
    func retrive(label: String) -> String {
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        req.predicate = NSPredicate(format: "\(CD_Key.key) = %@", "\(label)")
        
        do {
            let language = try dbContext.fetch(req)
            if language.count > 0 {
                
                return language[0].value ?? self.prepareExceptionLabel(label: label)
            }
        } catch {
            
        }
        return self.prepareExceptionLabel(label: label)
    }
    
    private func prepareExceptionLabel(label: String) -> String {
        
        let lb = label.replacingOccurrences(of: "_", with: " ")
        return lb.capitalizingFirstLetter()
    }
    
    private func retriveAll() -> [Language] {
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        
        do {
            let arrLanguage = try dbContext.fetch(req)
            return arrLanguage
            
        } catch {
            
        }
        
        return []
    }
    
    
    
    private func delete(label: String) {
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        req.predicate = NSPredicate(format: "\(CD_Key.key) = %@", "\(label)")
        
        do {
            let language = try dbContext.fetch(req)
            if language.count > 0 {
                print("CD LANG:- DELETE: \(label) => DONE")
                self.dbContext.delete(language[0])
                self.saveContext()
            }
        } catch {
            
        }
    }
    
    
    
    private func deleteAll() {
        
        let reqFetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.tblLanguage.name!)
        let reqDelete: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: reqFetch)

        do {
            try self.dbContext.execute(reqDelete)
            print("CD LANG:- DELETE ALL DONE")
            self.saveContext()
        } catch {

        }
    }
    
    
    
    
    
    
    
    private let UD = UserDefaults.standard
    private let key_currentLanguage = "CurrentLanguage"
    private let key_updatedAt = "UpdatedAt"
    
    func setLanguageID(langID: Int = 0, updated_date: String) {
        
        UD.set(langID, forKey: key_currentLanguage)
        UD.set(updated_date, forKey: key_updatedAt)
        UD.synchronize()
    }
    
    func getLanguageInfo() -> (langID: Int, updated_at: String) {
        
        let lan_id = UD.value(forKey: key_currentLanguage) as? Int ?? 0
        let update_date = UD.value(forKey: key_updatedAt) as? String ?? ""
        
        return (langID: lan_id, updated_at: update_date)
    }
    
    
    private func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: Date())
    }
    
}

