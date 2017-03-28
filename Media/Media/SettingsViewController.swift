//
//  Settings.swift
//  Media
//
//  Created by Tuuu on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingsViewController: BasicViewController {
    
    @IBOutlet weak var lbl_CountDown: UILabel!
    @IBOutlet weak var bannerSettings: GADBannerView!
    @IBOutlet weak var defaultBrowserLink: UITextField!
    @IBOutlet weak var switch_SetPassCode: UISwitch!
    @IBOutlet weak var switch_FakePassCode: UISwitch!
    @IBOutlet weak var txt_FakeCode: UITextField!
    var timer: Timer?
    var counter = 3
    var settingsViewModel = SettingsViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showDataFromSettings()
        settingsViewModel.configTouchID()
    }
    func timerFireMethod(_ timer: Timer) {
        counter -= 1
        if counter > 0 {
            lbl_CountDown.text = String(counter)
        } else {
            self.switch_FakePassCode.isHidden = false
            self.lbl_CountDown.isHidden = true
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWith(banner: self.bannerSettings, id: "ca-app-pub-5942433079799456/6755850323")
        self.bannerSettings.load(GADRequest())
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        self.view.addGestureRecognizer(tap)
        settingsViewModel.delegate = self
        
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-5942433079799456/7359782729")
        self.switch_FakePassCode.isHidden = true
        self.lbl_CountDown.isHidden = false
        self.counter = 3
        self.lbl_CountDown.text = String(self.counter)
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector:#selector(timerFireMethod(_:)),
                                     userInfo: nil,
                                     repeats: true)
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
        self.playVideoAdMob()
    }
    @IBAction func rateApp(_ sender: Any) {
        self.rateApp(appId: "1220344250") { (finished) in
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
