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

        myPageScrollView.backgroundColor = UIColor.red
        myPageScrollView.translatesAutoresizingMaskIntoConstraints = false

        
        let horizontalConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -100)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        myPageScrollView.loadSubViews()
    }
}
extension NVTWebView: HGPageScrollViewDataSource
{
    func numberOfPages(in scrollView: HGPageScrollView!) -> Int {
        return webviewModel.myPageDataArray.count
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, viewForPageAt index: Int) -> HGPageView! {
//        var currentWebView = webviewModel.myPageDataArray[index] as! MyPageView
        var customWebView = scrollView.dequeueReusablePage(withIdentifier: pageId) as? CustomWebView
        if (customWebView == nil)
        {
//           customWebView = Bundle.main.loadNibNamed("CustomWebView", owner: self, options: nil)?.first as? CustomWebView

            customWebView = CustomWebView(frame: CGRect(x:0, y:0, width: self.view.frame.width*0.75, height: 400))
        }
        customWebView?.loadRequest()
//        customWebView = webviewModel.setupDataToView(currentView: customWebView)
        return customWebView
        
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
class CustomView: HGPageView
{}
