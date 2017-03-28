//
//  DetailFile.swift
//  Media
//
//  Created by Tuuu on 2/20/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class DetailFile: BasicViewController {
    var urlFile: URL!
    var webView: WKWebView!
    
    @IBOutlet weak var banner_DetailFile: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWith(banner: self.banner_DetailFile, id: "ca-app-pub-5942433079799456/9848917526")
        self.banner_DetailFile.load(GADRequest())
        addWebView()
        webView.load(URLRequest(url: urlFile))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func addWebView()
    {
        webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 105)
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }

}
