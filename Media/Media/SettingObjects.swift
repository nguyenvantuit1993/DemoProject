//
//  Settings.swift
//  Media
//
//  Created by Tuuu on 2/24/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import CoreData

class SettingObjects{
    var passCodeLock: Bool!
    var removeAds: Bool!
    var retrievePurchases: Bool!
    var rateApp: Bool!
    var wifiTransfer: Bool!
    var backup: Bool!
    var browser: String!
    var privateBrowsing: Bool!
    var clearBrowserHitory: Bool!
    var settings = [NSManagedObject]()
    var managedContext: NSManagedObjectContext!
    
    //MARK: Shared Instance
    
    static let sharedInstance : SettingObjects = {
        let instance = SettingObjects()
        return instance
    }()
    //MARK: Init
    
    init() {
        
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            settings = results as! [NSManagedObject]
            getDataToProperties()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func getDataToProperties()
    {
        let setting = settings.first
        passCodeLock = ((setting?.value(forKey: SettingTypes.passCodeLock.rawValue)) != nil)
        removeAds = ((setting?.value(forKey: SettingTypes.removeAds.rawValue)) != nil)
        retrievePurchases = ((setting?.value(forKey: SettingTypes.retrievePurchases.rawValue)) != nil)
        rateApp = ((setting?.value(forKey: SettingTypes.rateApp.rawValue)) != nil)
        wifiTransfer = ((setting?.value(forKey: SettingTypes.wifiTransfer.rawValue)) != nil)
        backup = ((setting?.value(forKey: SettingTypes.backup.rawValue)) != nil)
        browser = (setting?.value(forKey: SettingTypes.browser.rawValue) as! String)
        privateBrowsing = ((setting?.value(forKey: SettingTypes.clearBrowserHitory.rawValue)) != nil)
        clearBrowserHitory = ((setting?.value(forKey: "clearBrowserHitory")) != nil)
    }
    func removeObjectAt(index: Int)
    {
        if let bookmark =  settings[index] as? NSManagedObject
        {
            managedContext.delete(bookmark)
            try? managedContext.save()
        }
    }
    func saveSettings() {
        
        for index in 0..<self.settings.count
        {
            removeObjectAt(index: index)
        }
        settings.removeAll()
        
        let entity =  NSEntityDescription.entity(forEntityName: "Settings",
                                                 in:managedContext)
        
        let setting = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        //3
        setting.setValue(self.passCodeLock, forKey: SettingTypes.passCodeLock.rawValue)
        setting.setValue(self.removeAds, forKey: SettingTypes.removeAds.rawValue)
        setting.setValue(self.retrievePurchases, forKey: SettingTypes.retrievePurchases.rawValue)
        setting.setValue(self.rateApp, forKey: SettingTypes.rateApp.rawValue)
        setting.setValue(false, forKey: SettingTypes.wifiTransfer.rawValue)
        setting.setValue(self.backup, forKey: SettingTypes.backup.rawValue)
        setting.setValue(self.browser, forKey: SettingTypes.browser.rawValue)
        setting.setValue(self.privateBrowsing, forKey: SettingTypes.privateBrowsing.rawValue)
        setting.setValue(self.clearBrowserHitory, forKey: SettingTypes.clearBrowserHitory.rawValue)


        //4
        do {
            try managedContext.save()
            //5
            settings.append(setting)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
