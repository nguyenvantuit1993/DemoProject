//
//  NVTWebView.swift
//  CustomWebView
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
import CoreData
import AssetsLibrary
class NVTWebView: UIViewController{
    var myPageScrollView: HGPageScrollView!
    var webviewModel = NVTWebViewModel()
    var toolBar: BaseToolBar!
    let pageId = "pageId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageScrollView()
        addToolBar()
    }
    func addToolBar()
    {
        if(toolBar == nil)
        {
            toolBar = ToolBarNewPage(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        }
        else
        {
            toolBar.removeFromSuperview()
            if(toolBar.isToolBarNewPage == true)
            {
                toolBar = ToolBarDetail(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
                
            }
            else
            {
                toolBar = ToolBarNewPage(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            }
            
        }
        toolBar.delegate = self
        self.view.addSubview(self.toolBar)
        layoutToolBar()
    }
    func layoutToolBar()
    {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: toolBar, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: toolBar, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: toolBar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        
        let verticalConstraint = NSLayoutConstraint(item: toolBar, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -40)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        toolBar.layoutIfNeeded()
    }
    func addPageScrollView()
    {
        self.view.layoutIfNeeded()
        myPageScrollView = Bundle.main.loadNibNamed("HGPageScrollView", owner: self, options: nil)?.first as! HGPageScrollView!
        self.view.addSubview(myPageScrollView)
        
        myPageScrollView.backgroundColor = UIColor.red
        myPageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let horizontalConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -80)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        myPageScrollView.loadSubViews()
    }
}
extension NVTWebView: CustomWebViewDelegate
{
    func didShowAler(tags:String, href:String, src:String) {
        var title: String!
        var buttons = [UIAlertAction]()
        if(tags.range(of: ",IMG,") != nil)
        {
            title = src
            
            let dowloadFile = UIAlertAction(title: "Download the Image", style: .default) { action -> Void in
                let newTrack = Track(name: src, artist: "", previewUrl: src)
                ManageDownloadTrack.sharedInstance.addNewTrack(newTrack)
            }
            dowloadFile.setValue(UIColor.red, forKey: "titleTextColor")
            buttons.append(dowloadFile)
        }
        if(tags.lowercased().range(of: ",A,") != nil || tags.lowercased().range(of:"video") != nil)
        {
            let currentWebView = self.webviewModel.getPage(indexPage: self.myPageScrollView.indexForSelectedPage())
            title = href
            if(!href.lowercased().hasPrefix("http") && !src.lowercased().hasPrefix("http"))
            {
                currentWebView?.isPosibleLoad = true
                currentWebView?.runScriptString(script: title)
                return
            }
            
            
            let dowloadFile = UIAlertAction(title: "Download the File", style: .default) { action -> Void in
                let titleAlert = href == "" ? src:href
                let newTrack = Track(name: titleAlert, artist: "", previewUrl: titleAlert)
                ManageDownloadTrack.sharedInstance.addNewTrack(newTrack)
            }
            dowloadFile.setValue(UIColor.red, forKey: "titleTextColor")
            let open: UIAlertAction = UIAlertAction(title: "Open", style: .default) { action -> Void in
                if(title.hasPrefix("http"))
                {
                    currentWebView?.loadRequest(url: title, isPosibleLoad: true)
                }
                
            }
            
            buttons.append(dowloadFile)
            buttons.append(open)
        }
        if(buttons.count > 0)
        {
            let titleAlert = href == "" ? src:href
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            buttons.insert(cancelAction, at: 0)
            self.showActionSheet(title: titleAlert, buttons: buttons)
        }
    }
    
    func showActionSheet(title: String, buttons:[UIAlertAction])
    {
        let actionSheet = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
//            //Just dismiss the action sheet
//        }
//        let dowloadFile: UIAlertAction = UIAlertAction(title: "Download the File", style: .default) { action -> Void in
//            
//        }
//        dowloadFile.setValue(UIColor.red, forKey: "titleTextColor")
//        
//        let open: UIAlertAction = UIAlertAction(title: "Open", style: .default) { action -> Void in
//
//            self.webviewModel.getPage(indexPage: self.myPageScrollView.indexForSelectedPage())?.loadRequest(url: title, isPosibleLoad: true)
//        }
//        actionSheet.addAction(dowloadFile)
//        actionSheet.addAction(open)
        for button in buttons
        {
            actionSheet.addAction(button)
        }
        self.present(actionSheet, animated: true, completion: nil)
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
            customWebView = self.webviewModel.myPageDataArray[index] as? CustomWebView
            //            customWebView = CustomWebView(frame: CGRect(x:0, y:0, width: self.myPageScrollView.frame.width*0.65, height: self.myPageScrollView.frame.height*0.8 - 160))
        }
        customWebView?.delegateCustomWeb = self
        customWebView?.loadRequest(url: "https://www.youtube.com/", isPosibleLoad: true)
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
        self.addToolBar()
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, didSelectPageAt index: Int) {
        self.addToolBar()
    }
    
}
extension NVTWebView: ToolBarDelegate
{
    func actionBrowser()
    {
        self.webviewModel.browserWith(pageScrollView: self.myPageScrollView)
    }
    func addNewPage()
    {
        self.webviewModel.addNewLastPageTo(pageScrollView: self.myPageScrollView)
        //        actionBrowser()
    }
    func showCurrentPage()
    {
        self.actionBrowser()
    }
    func showPreviousPage()
    {
        self.webviewModel.goBack(indexPage:self.myPageScrollView.indexForSelectedPage())
    }
    func showForwardPage()
    {
        self.webviewModel.goForward(indexPage:self.myPageScrollView.indexForSelectedPage())
    }
    func actionBookMark()
    {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        let addbookmark: UIAlertAction = UIAlertAction(title: "Add Bookmark", style: .default) { action -> Void in
            self.webviewModel.savePageToBookmark(indexPage: self.myPageScrollView.indexForSelectedPage())
            
        }
        addbookmark.setValue(UIColor.red, forKey: "titleTextColor")
        let gotoBookmark: UIAlertAction = UIAlertAction(title: "Go to Bookmark", style: .default) { action -> Void in
            let bookmarView = self.webviewModel.getBookMark()
            self.tabBarController?.navigationController?.pushViewController(bookmarView, animated: true)
            //Just dismiss the action sheet
        }
        let settings: UIAlertAction = UIAlertAction(title: "Settings", style: .default) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(addbookmark)
        actionSheet.addAction(gotoBookmark)
        actionSheet.addAction(settings)
        self.present(actionSheet, animated: true, completion: nil)
    }
    func showBrowser()
    {
        self.actionBrowser()
    }
    func showDownloadView()
    {
        self.tabBarController?.navigationController?.pushViewController(self.webviewModel.getDownloadView(indexPage:self.myPageScrollView.indexForSelectedPage()), animated: true)
    }
    func zoom()
    {
        
    }
    func switchToolBar()
    {
        
    }
}

