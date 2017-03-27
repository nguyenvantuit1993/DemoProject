//
//  BasicViewController.swift
//  Media
//
//  Created by tuios on 3/16/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
import GoogleMobileAds
class BasicViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    override func viewDidLoad() {
        
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = [kGADSimulatorID]
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-5942433079799456/7359782729")
        
        interstitial = createAndLoadInterstitial()
    }
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-8501671653071605/1974659335"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    var interstitial: GADInterstitial?
    var rewardVideo: GADRewardBasedVideoAd?
    
    
    func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-5942433079799456/5883049523")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    func playInterstitailAdMod()
    {
        if(interstitial != nil)
        {
            if (interstitial?.isReady)!
            {
                interstitial?.present(fromRootViewController: self)
            }
            
        }
    }
    func playVideoAdMob()
    {
        if GADRewardBasedVideoAd.sharedInstance().isReady {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }

}
