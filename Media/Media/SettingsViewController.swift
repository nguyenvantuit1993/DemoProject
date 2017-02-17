//
//  Settings.swift
//  Media
//
//  Created by Tuuu on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var switch_SetPassCode: UISwitch!
    var settingsViewModel = SettingsViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsViewModel.configTouchID()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewModel.delegate = self
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
