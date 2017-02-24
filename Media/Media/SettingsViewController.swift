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
        settingsViewModel.configTouchID()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewModel.delegate = self
        showDataFromSettings()
    }
    func showDataFromSettings()
    {
        let dic = settingsViewModel.getData()
        defaultBrowserLink.text = dic[SettingTypes.Browser.rawValue] as! String?
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.settingsViewModel.setDataForSettings(dic: getDataFromView())
    }
    func getDataFromView() -> Dictionary<String, Any>
    {
        return [SettingTypes.Browser.rawValue: defaultBrowserLink.text!,
                    SettingTypes.PassCodeLock.rawValue: switch_SetPassCode.isOn,
                    SettingTypes.WifiTransfer.rawValue: switch_WifiTransfer.isOn,
                    SettingTypes.Backup.rawValue: switch_Backup.isOn,
                    SettingTypes.PriteBrowsing.rawValue: switch_PrivateBrowsing.isOn] as [String : Any]
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
