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
    var settings: Settings!
    
    //MARK: Shared Instance
    static let sharedInstance : SettingObjects = {
        let instance = SettingObjects()
        return instance
    }()
    //MARK: Init
    
    init() {
        getData()
    }
    func getData()
    {
        if let currentSettings = ManageDataBase.sharedInstance.fetchEntity(name: "Settings").first as? Settings
        {
            settings = currentSettings
        }
        
        
        getDataToProperties()
    }
    func getDataToProperties()
    {

        let settings = self.settings
        passCodeLock = settings?.passCodeLock ?? false
        removeAds = settings?.removeAds ?? false
        retrievePurchases = settings?.retrievePurchases ?? false
        rateApp = settings?.rateApp ?? false
        wifiTransfer = settings?.wifiTransfer ?? false
        backup = settings?.backup ?? false
        browser = settings?.browser ?? ""
        privateBrowsing = settings?.privateBrowsing ?? false
        clearBrowserHitory = settings?.clearBrowserHitory ?? false
    }

    func saveSettings() {
        let managedContext = ManageDataBase.sharedInstance.managedContext
        let entity =  NSEntityDescription.entity(forEntityName: "Settings",
                                                 in:managedContext!)
        var settings:Settings!
        if let currentSettings = self.settings
        {
            settings = currentSettings
        }
        else
        {
            settings = Settings(entity: entity!,
                                insertInto: managedContext)
            
        }
        //3
        settings.passCodeLock = self.passCodeLock
        settings.removeAds = self.removeAds
        settings.retrievePurchases = self.retrievePurchases
        settings.rateApp = self.rateApp
        settings.wifiTransfer = self.wifiTransfer
        settings.backup = self.backup
        settings.browser = self.browser
        settings.privateBrowsing = self.privateBrowsing
        settings.clearBrowserHitory = self.clearBrowserHitory
        
        
//        setting.setValue(self.passCodeLock, forKey: SettingTypes.passCodeLock.rawValue)
//        setting.setValue(self.removeAds, forKey: SettingTypes.removeAds.rawValue)
//        setting.setValue(self.retrievePurchases, forKey: SettingTypes.retrievePurchases.rawValue)
//        setting.setValue(self.rateApp, forKey: SettingTypes.rateApp.rawValue)
//        setting.setValue(self.wifiTransfer, forKey: SettingTypes.wifiTransfer.rawValue)
//        setting.setValue(self.backup, forKey: SettingTypes.backup.rawValue)
//        setting.setValue(self.browser, forKey: SettingTypes.browser.rawValue)
//        setting.setValue(self.privateBrowsing, forKey: SettingTypes.privateBrowsing.rawValue)
//        setting.setValue(self.clearBrowserHitory, forKey: SettingTypes.clearBrowserHitory.rawValue)


        //4
        do {
            try managedContext?.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
