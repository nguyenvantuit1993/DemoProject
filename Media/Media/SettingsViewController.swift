//
//  Settings.swift
//  Media
//
//  Created by Tuuu on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class SettingsViewController: BasicViewController {
    
    @IBOutlet weak var defaultBrowserLink: UITextField!
    @IBOutlet weak var switch_SetPassCode: UISwitch!
    @IBOutlet weak var switch_FakePassCode: UISwitch!
    @IBOutlet weak var txt_FakeCode: UITextField!
    
    var settingsViewModel = SettingsViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        txt_FakeCode.text = dic[SettingTypes.fakeCodeString.rawValue] as! String?
        switch_FakePassCode.isOn = (dic[SettingTypes.fakeCodeLock.rawValue] as! Bool?)!
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.settingsViewModel.setDataForSettings(dic: getDataFromView())
    }
    func getDataFromView() -> Dictionary<String, Any>
    {
        let fakeCodeString = txt_FakeCode.text!
        return [SettingTypes.browser.rawValue: self.defaultBrowserLink.text!,
                    SettingTypes.passCodeLock.rawValue: self.switch_SetPassCode.isOn,
                    SettingTypes.fakeCodeLock.rawValue: self.switch_FakePassCode.isOn,
                    SettingTypes.fakeCodeString.rawValue: fakeCodeString,
                    SettingTypes.privateBrowsing.rawValue: false] as [String : Any]
    }
    @IBAction func userTappedSetPasscode(_ sender: UISwitch) {
        self.settingsViewModel.setPassCode()
    }
    @IBAction func userTappedSetFakePass(_ sender: AnyObject) {
    }
    @IBAction func rateApp(_ sender: Any) {
        self.rateApp(appId: "1209839038") { (finished) in
            if(finished == true)
            {
                print("ok")
            }
            else
            {
                print("cancel")
            }
        }
    }
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
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
    func userShowPassCode(view: VENTouchLockEnterPasscodeViewController) {
        view.isSettingsView = true
        self.present(view.embeddedInNavigationController(), animated: true, completion: nil)
    }
}
