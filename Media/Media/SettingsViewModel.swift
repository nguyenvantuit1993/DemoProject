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
    case PassCodeLock,
    RemoveAds,
    RetrievePurchases,
    RateApp,
    WifiTransfer,
    Backup,
    Browser,
    PriteBrowsing,
    ClearBrowserHitory
}
protocol SettingsViewModelDelegate {
    func configureTouchIDToogle(enable: Bool)
    func userTappedSetPassCode(view: VENTouchLockCreatePasscodeViewController)
    func userShowPassCode(view: CustomVENTouchLockEnterPasscodeViewController)
}
class SettingsViewModel{
    var delegate: SettingsViewModelDelegate!
    let settings = Settings.sharedInstance
    //MARK data Settings
    func getData() -> Dictionary<String, Any>
    {
        let dic = [SettingTypes.PassCodeLock.rawValue :settings.passCodeLock,
                   SettingTypes.RemoveAds.rawValue:settings.removeAds,
                   SettingTypes.RetrievePurchases.rawValue:settings.retrievePurchases,
                   SettingTypes.RateApp.rawValue:settings.rateApp,
                   SettingTypes.WifiTransfer.rawValue:settings.wifiTransfer,
                   SettingTypes.Backup.rawValue:settings.backup,
                   SettingTypes.Browser.rawValue:settings.browser,
                   SettingTypes.PriteBrowsing.rawValue:settings.priteBrowsing,
                   SettingTypes.ClearBrowserHitory.rawValue:settings.clearBrowserHitory] as [String : Any]
        return dic
    }
    func setDataForSettings(dic: Dictionary<String, Any>)
    {
        for key in dic.keys
        {
            let value = dic[key]
            switch key {
            case SettingTypes.PassCodeLock.rawValue:
                settings.passCodeLock = (value as? Bool)!     
                break
            case SettingTypes.RemoveAds.rawValue:
                settings.removeAds = (value as? Bool)!
                break
            case SettingTypes.RetrievePurchases.rawValue:
                settings.retrievePurchases = (value as? Bool)!
                break
            case SettingTypes.RateApp.rawValue:
                settings.rateApp = (value as? Bool)!
                break
            case SettingTypes.WifiTransfer.rawValue:
                settings.wifiTransfer = (value as? Bool)!
                break
            case SettingTypes.Backup.rawValue:
                settings.backup = (value as? Bool)!
                break
            case SettingTypes.Browser.rawValue:
                settings.browser = self.validLink(link: (value as? String)!)
                break
            case SettingTypes.PriteBrowsing.rawValue:
                settings.priteBrowsing = (value as? Bool)!
                break
            case SettingTypes.ClearBrowserHitory.rawValue:
                settings.clearBrowserHitory = (value as? Bool)!
                break
            default:
                break
            }
        }
    }
    func validLink(link: String) -> String
    {
        var linkToReturn: String!
        if(link.hasPrefix("http") == false)
        {
            linkToReturn = "http://\(link)"
        }
        else
        {
            linkToReturn = link
        }
        return linkToReturn
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
            self.delegate.userShowPassCode(view: CustomVENTouchLockEnterPasscodeViewController(true))
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
