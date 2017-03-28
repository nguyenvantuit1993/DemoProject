//
//  BasicViewController.swift
//  Media
//
//  Created by tuios on 3/16/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
import GoogleMobileAds
class BasicViewController: UIViewController, GADBannerViewDelegate {
    var rewardVideo: GADRewardBasedVideoAd?
    
    override func viewDidLoad() {
        
        
        

    }
//    lazy var adBannerView: GADBannerView = {
//        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        adBannerView.adUnitID = "ca-app-pub-8501671653071605/1974659335"
//        adBannerView.delegate = self
//        adBannerView.rootViewController = self
//        
//        return adBannerView
//    }()
    
    func setupWith(banner: GADBannerView, id: String = "ca-app-pub-5942433079799456/4406316321")
    {
        banner.adUnitID = id
        banner.rootViewController = self
    }
    func setupWith(interstitial: GADInterstitial)
    {
        let request = GADRequest()
        interstitial.load(request)
    }
    func playInterstitailAdMod(interstitial: GADInterstitial?)
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
