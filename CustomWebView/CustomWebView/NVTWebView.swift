//
//  NVTWebView.swift
//  CustomWebView
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class NVTWebView: UIViewController{
    var myPageScrollView: HGPageScrollView!
    var webviewModel = NVTWebViewModel()
    let pageId = "pageId"
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageScrollView()
    }
    func addPageScrollView()
    {
        myPageScrollView = Bundle.main.loadNibNamed("HGPageScrollView", owner: self, options: nil)?.first as! HGPageScrollView!
        self.view.addSubview(myPageScrollView)
    }
}
extension NVTWebView: HGPageScrollViewDataSource
{
    func numberOfPages(in scrollView: HGPageScrollView!) -> Int {
        return webviewModel.myPageDataArray.count
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, viewForPageAt index: Int) -> HGPageView! {
        var currentWebView = webviewModel.myPageDataArray[index] as! CustomWebView
        if let customWebView = scrollView.dequeueReusablePage(withIdentifier: pageId) as? CustomWebView
        {
            currentWebView = customWebView
        }
        currentWebView.loadRequest()
        currentWebView = webviewModel.setupDataToView(currentView: currentWebView)
        currentWebView.frame.size.height = 420
        return currentWebView
        
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, titleForPageAt index: Int) -> String! {
        return "title"
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, subtitleForPageAt index: Int) -> String! {
        return "subTitle"
    }
}
extension NVTWebView: HGPageScrollViewDelegate
{
    func pageScrollView(_ scrollView: HGPageScrollView!, didDeselectPageAt index: Int) {
        
    }
}
