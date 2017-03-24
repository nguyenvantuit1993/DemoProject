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
class NVTWebView: BasicViewController{
    var myPageScrollView: HGPageScrollView!
    var webviewModel: NVTWebViewModel!
    var toolBar: BaseToolBar!
    let pageId = "pageId"
    var verticalConstraint: NSLayoutConstraint! = nil
    var fakeView:FakeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define identifier
        let notificationName = Notification.Name("LoginFakeView")
        NotificationCenter.default.addObserver(self, selector: #selector(loginFakeView), name: notificationName, object: nil)
        let notificationLoginName = Notification.Name("Login")
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: notificationLoginName, object: nil)
        
        webviewModel = NVTWebViewModel(size: self.view.bounds.size)
        addPageScrollView()
        addToolBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func login()
    {
        self.fakeView?.dismiss(animated: true, completion: nil)
        self.tabBarController?.view.isHidden = false
    }
    func loginFakeView()
    {
        self.tabBarController?.view.isHidden = true
        self.fakeView = FakeView(nibName: "FakeView", bundle: nil)
        self.present(fakeView, animated: false, completion: nil)
    }
    func interactPage(index: Int, isSelected: Bool)
    {
        addToolBar()
        hidenSearchBar(at: index, isHidden: !isSelected)
        
    }
    func hidenSearchBar(at index: Int, isHidden: Bool)
    {
        self.webviewModel.getPage(indexPage: index)?.hiddenSearchBar(hidden: isHidden)
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
        
        let heightConstraint = NSLayoutConstraint(item: toolBar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 45)
        
        verticalConstraint = NSLayoutConstraint(item: toolBar, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -49)
        
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
        myPageScrollView.layoutIfNeeded()
    }
}
extension NVTWebView: CustomWebViewDelegate
{
    func didShowAler(tags:String, href:String, src:String) {
        var title: String!
        let currentWebView = self.webviewModel.getPage(indexPage: self.myPageScrollView.indexForSelectedPage())
        currentWebView?.isPosibleLoad = true
        if(!href.lowercased().hasPrefix(kHtmlPath) && !src.lowercased().hasPrefix(kHtmlPath))
        {
            currentWebView?.runScriptString(script: href == "" ? src:href )
            return
        }
        var buttons = [UIAlertAction]()
        if(tags.range(of: ",IMG,") != nil)
        {
            title = src
            
            let dowloadFile = UIAlertAction(title: "Download the Image", style: .default) { action -> Void in
                self.setFileToDownload(title: title)
            }
            dowloadFile.setValue(UIColor.red, forKey: "titleTextColor")
            buttons.append(dowloadFile)
        }
        if(title != src && (href != "" || src != ""))
        {
            title = href == "" ? src:href
            let dowloadFile = UIAlertAction(title: "Download the File", style: .default) { action -> Void in
                self.setFileToDownload(title: title)
            }
            dowloadFile.setValue(UIColor.red, forKey: "titleTextColor")
            let open = UIAlertAction(title: "Open", style: .default) { action -> Void in
                if(title.hasPrefix(kHtmlPath))
                {
                    currentWebView?.loadRequest(url: title, isPosibleLoad: true)
                }
                
            }
            
            buttons.append(dowloadFile)
            buttons.append(open)
        }
        
        
        if(buttons.count > 0)
        {
            var titleAlert = title
            if titleAlert == nil
            {
                titleAlert = href == "" ? src:href
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                
            }
            buttons.insert(cancelAction, at: 0)
            self.showActionSheet(title: titleAlert!, buttons: buttons)
        }
    }
    func setFileToDownload(title: String)
    {
        self.showActionInfoFile(title: title)
    }
    func showActionInfoFile(title: String)
    {
        self.present(Alert.showActionInfoFile(title: title, isDownloadView: false), animated: true, completion: nil)
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
    func activeTabBar()
    {
        self.tabBarController?.tabBar.alpha = 1
        toolBar.zoomAction(isZoomIn: false)
        verticalConstraint.constant = -49
    }
    func hiddenTabBar()
    {
        self.tabBarController?.tabBar.alpha = 0
        toolBar.zoomAction(isZoomIn: true)
        verticalConstraint.constant = 0
    }
}
extension NVTWebView: HGPageScrollViewDataSource
{
    func numberOfPages(in scrollView: HGPageScrollView!) -> Int {
        return self.webviewModel.myPageDataArray.count
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, viewForPageAt index: Int) -> HGPageView! {
        //        var currentWebView = webviewModel.myPageDataArray[index] as! MyPageView
        var customWebView = self.webviewModel.getPage(indexPage: index)
        //        if (customWebView == nil)
        //        {
        //           customWebView = Bundle.main.loadNibNamed("CustomWebView", owner: self, options: nil)?.first as? CustomWebView
        //            customWebView = self.webviewModel.myPageDataArray[index] as? CustomWebView
        //            customWebView = CustomWebView(frame: CGRect(x:0, y:0, width: self.myPageScrollView.frame.width*0.65, height: self.myPageScrollView.frame.height*0.8 - 160))
        //        }
        customWebView?.delegateCustomWeb = self
        customWebView?.loadRequest(url: SettingObjects.sharedInstance.browser, isPosibleLoad: true)
        //        customWebView = webviewModel.setupDataToView(currentView: customWebView)
        return customWebView
        
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, titleForPageAt index: Int) -> String! {
        print(self.webviewModel.getTitle(index: index))
        return self.webviewModel.getTitle(index: index)
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, subtitleForPageAt index: Int) -> String! {
        print(self.webviewModel.getSubTitle(index: index))
        return self.webviewModel.getSubTitle(index: index)
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, headerViewForPageAt index: Int) -> UIView! {
        let view  = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view.backgroundColor = UIColor.red
        return view
    }
}
extension NVTWebView: HGPageScrollViewDelegate
{
    func pageScrollView(_ scrollView: HGPageScrollView!, willDeselectPageAt index: Int) {
        self.interactPage(index: index, isSelected: false)
    }
    func pageScrollView(_ scrollView: HGPageScrollView!, didSelectPageAt index: Int) {
        self.interactPage(index: index, isSelected: true)
    }
    func willRemovePage(_ index: Int) {
        self.webviewModel.removePageFrom(pageScrollView: self.myPageScrollView, atIndex: index)
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
            bookmarView.delegate = self
            self.present(bookmarView, animated: true, completion: nil)
            //            self.tabBarController?.navigationController?.pushViewController(bookmarView, animated: true)
            //Just dismiss the action sheet
        }

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(addbookmark)
        actionSheet.addAction(gotoBookmark)
        self.present(actionSheet, animated: true, completion: nil)
    }
    func showBrowser()
    {
        self.activeTabBar()
        self.actionBrowser()
    }
    func showDownloadView()
    {
        self.present(self.webviewModel.getDownloadView(indexPage:self.myPageScrollView.indexForSelectedPage()), animated: true, completion: nil)
        //        self.tabBarController?.navigationController?.pushViewController(self.webviewModel.getDownloadView(indexPage:self.myPageScrollView.indexForSelectedPage()), animated: true)
    }
    func zoom()
    {
        if(self.verticalConstraint.constant == -49)
        {
            self.hiddenTabBar()
        }
        else
        {
            self.activeTabBar()
        }
    }
    func switchToolBar()
    {
        
    }
}
extension NVTWebView: BookMarkDelegate
{
    func didSelectBookMarkAt(index: Int)
    {
        self.webviewModel.browserWith(pageScrollView: self.myPageScrollView)
        if(self.webviewModel.checkFirstView())
        {
            self.webviewModel.getPage(indexPage: 0)?.loadRequest(url: (BookMarkObjects.sharedInstance.bookmarks[index].value(forKey: "url") as? String)!, isPosibleLoad: true)
        }
        else
        {
            self.webviewModel.addNewLastPageTo(pageScrollView: self.myPageScrollView)
            self.webviewModel.getLastPage()?.loadRequest(url: (BookMarkObjects.sharedInstance.bookmarks[index].value(forKey: "url") as? String)!, isPosibleLoad: true)
        }
//        self.webviewModel.browserWith(pageScrollView: self.myPageScrollView)
    }
}

