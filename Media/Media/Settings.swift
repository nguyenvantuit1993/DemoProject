//
//  Settings.swift
//  Media
//
//  Created by Tuuu on 2/24/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
class Settings{
    var passCodeLock = true
    var removeAds = true
    var retrievePurchases = true
    var rateApp = true
    var wifiTransfer = true
    var backup = true
    var browser = "http://google.com"
    var priteBrowsing = true
    var clearBrowserHitory = true
    static let sharedInstance : Settings = {
        let instance = Settings()
        return instance
    }()
}
