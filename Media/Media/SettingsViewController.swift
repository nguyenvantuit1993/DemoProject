//
//  Settings.swift
//  Media
//
//  Created by Tuuu on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var defaultBrowserLink: UITextField!
    @IBOutlet weak var switch_SetPassCode: UISwitch!
    @IBOutlet weak var switch_WifiTransfer: UISwitch!
    @IBOutlet weak var switch_Backup: UISwitch!
    @IBOutlet weak var switch_PrivateBrowsing: UISwitch!
    
    var settingsViewModel = SettingsViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        for cookie in HTTPCookieStorage.shared.cookies!
        {
            print(cookie)
        }
        showDataFromSettings()
        settingsViewModel.configTouchID()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        self.view.addGestureRecognizer(tap)
        settingsViewModel.delegate = self
    }
    func dissmissKeyboard()
    {
        self.view.endEditing(true)
        
        
    }
    func showDataFromSettings()
    {
        let dic = settingsViewModel.getData()
        defaultBrowserLink.text = dic[SettingTypes.browser.rawValue] as! String?
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.settingsViewModel.setDataForSettings(dic: getDataFromView())
    }
    func getDataFromView() -> Dictionary<String, Any>
    {
        return [SettingTypes.browser.rawValue: self.defaultBrowserLink.text!,
                    SettingTypes.passCodeLock.rawValue: self.switch_SetPassCode.isOn,
                    SettingTypes.wifiTransfer.rawValue: self.switch_WifiTransfer.isOn,
                    SettingTypes.backup.rawValue: self.switch_Backup.isOn,
                    SettingTypes.privateBrowsing.rawValue: self.switch_PrivateBrowsing.isOn] as [String : Any]
    }
    @IBAction func userTappedSetPasscode(_ sender: UISwitch) {
        self.settingsViewModel.setPassCode()
    }

}
extension SettingsViewController: SettingsViewModelDelegate
{

    func configureTouchIDToogle(enable: Bool) {
        switch_SetPassCode.isOn = enable
    }
    func userTappedSetPassCode(view: VENTouchLockCreatePasscodeViewController) {
        self.present(view.embeddedInNavigationController(), animated: true, completion: nil)
    }
    func userShowPassCode(view: CustomVENTouchLockEnterPasscodeViewController) {
        self.present(view.embeddedInNavigationController(), animated: true, completion: nil)
    }
}
