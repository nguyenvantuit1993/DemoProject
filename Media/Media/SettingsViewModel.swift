//
//  SettingsViewModel.swift
//  Media
//
//  Created by Tuuu on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit


protocol SettingsViewModelDelegate {
    func configureTouchIDToogle(enable: Bool)
    func userTappedSetPassCode(view: VENTouchLockCreatePasscodeViewController)
    func userShowPassCode(view: CustomVENTouchLockEnterPasscodeViewController)
}
class SettingsViewModel{
    var delegate: SettingsViewModelDelegate!
    
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
