//
//  SettingsViewModel.swift
//  Media
//
//  Created by Tuuu on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

enum SettingTypes: String
{
    case passCodeLock,
    isFakeLogin,
    fakeCodeLock,
    fakeCodeString,
    removeAds,
    retrievePurchases,
    rateApp,
    wifiTransfer,
    backup,
    browser,
    privateBrowsing,
    clearBrowserHitory
}
protocol SettingsViewModelDelegate {
    func configureTouchIDToogle(enable: Bool)
    func userTappedSetPassCode(view: VENTouchLockCreatePasscodeViewController)
    func userShowPassCode(view: VENTouchLockEnterPasscodeViewController)
}
class SettingsViewModel{
    var delegate: SettingsViewModelDelegate!
    
    //MARK data Settings
    func getData() -> Dictionary<String, Any>
    {
        let settings = SettingObjects.sharedInstance
        let dic = [SettingTypes.passCodeLock.rawValue :settings.passCodeLock,
                   SettingTypes.fakeCodeLock.rawValue :settings.fakeCodeLock,
                   SettingTypes.fakeCodeString.rawValue :settings.fakeCodeString,
                   SettingTypes.removeAds.rawValue:settings.removeAds,
                   SettingTypes.retrievePurchases.rawValue:settings.retrievePurchases,
                   SettingTypes.rateApp.rawValue:settings.rateApp,
                   SettingTypes.wifiTransfer.rawValue:settings.wifiTransfer,
                   SettingTypes.backup.rawValue:settings.backup,
                   SettingTypes.browser.rawValue:settings.browser,
                   SettingTypes.privateBrowsing.rawValue:settings.privateBrowsing,
                   SettingTypes.clearBrowserHitory.rawValue:settings.clearBrowserHitory] as [String : Any]
        return dic
    }
    func setDataForSettings(dic: Dictionary<String, Any>)
    {
        for key in dic.keys
        {
            let settings = SettingObjects.sharedInstance
            let value = dic[key]
            switch key {
            case SettingTypes.passCodeLock.rawValue:
                settings.passCodeLock = (value as? Bool)!     
                break
            case SettingTypes.fakeCodeLock.rawValue:
                settings.fakeCodeLock = (value as? Bool)!
                break
            case SettingTypes.fakeCodeString.rawValue:
                settings.fakeCodeString = (value as? String)!
                break
            case SettingTypes.removeAds.rawValue:
                settings.removeAds = (value as? Bool)!
                break
            case SettingTypes.retrievePurchases.rawValue:
                settings.retrievePurchases = (value as? Bool)!
                break
            case SettingTypes.rateApp.rawValue:
                settings.rateApp = (value as? Bool)!
                break
            case SettingTypes.wifiTransfer.rawValue:
                settings.wifiTransfer = (value as? Bool)!
                break
            case SettingTypes.backup.rawValue:
                settings.backup = (value as? Bool)!
                break
            case SettingTypes.browser.rawValue:
                settings.browser = (((value as? String)?.validLink())?.link)!
                break
            case SettingTypes.privateBrowsing.rawValue:
                settings.privateBrowsing = (value as? Bool)!
                break
            case SettingTypes.clearBrowserHitory.rawValue:
                settings.clearBrowserHitory = (value as? Bool)!
                break
            default:
                break
            }
        }
        SettingObjects.sharedInstance.saveSettings()
    }
    
    func checkValidPass()
    {
        if(VENTouchLock.sharedInstance().isPasscodeSet())
        {
            print("unLock")
        }
    }
    func setPassCode()
    {
        if(VENTouchLock.sharedInstance().isPasscodeSet())
        {
            self.delegate.userShowPassCode(view: VENTouchLockEnterPasscodeViewController(true))
        }
        else
        {
            let view = VENTouchLockCreatePasscodeViewController()
            self.delegate.userTappedSetPassCode(view: view)
        }
    }
    func deletePassCode()
    {
        VENTouchLock.sharedInstance().deletePasscode()
        configTouchID()
    }
    func configTouchID()
    {
        delegate.configureTouchIDToogle(enable:VENTouchLock.sharedInstance().isPasscodeSet())
    }
}
extension String
{
    func validLink() -> (link: String, isValid: Bool)
    {
        var linkToReturn = self
        var isValid = false
        
        let extention = (self as NSString).pathExtension
        if(self.hasPrefix(kHtmlPath) == true)
        {
            if(extention != "")
            {
                isValid = true
            }
            
        }
        else
        {
            if(extention != "")
            {
                linkToReturn = "http://\(self)"
                isValid = true
            }
        }
        return (linkToReturn, isValid)
    }
}
