//
//  NVTWebViewModel.swift
//  CustomWebView
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class NVTWebViewModel: NSObject{
    var myPageDataArray: NSMutableArray!
    var indexesToDelete, indexesToInsert, indexesToReload: NSMutableIndexSet!
    var manageDataBase: ManageDataBase!
    override init() {
        self.myPageDataArray = NSMutableArray()
        self.manageDataBase = ManageDataBase.sharedInstance
        let webview = CustomWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        let webview2 = CustomWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        self.myPageDataArray.add(webview)
        self.myPageDataArray.add(webview2)
    }
    func setupDataToView(currentView: CustomWebView) -> CustomWebView
    {
        return currentView
    }
    func goBack(indexPage: Int)
    {
        let webView = getPage(indexPage: indexPage)
        webView?.goBackPage()
    }
    func goForward(indexPage: Int)
    {
        let webView = getPage(indexPage: indexPage)
        webView?.goForwardPage()
    }
    func getBookMark()-> BookMarkView
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let bookmarkView = storyBoard.instantiateViewController(withIdentifier: "BookMarkView") as! BookMarkView
        return bookmarkView
    }
    func getDownloadView(indexPage: Int) -> DownloadView
    {
        let webView = getPage(indexPage: indexPage)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let downloadView = storyBoard.instantiateViewController(withIdentifier: "DownloadView") as! DownloadView
        downloadView.searchResults = (webView?.getURLs())!
        return downloadView
    }
    func getPage(indexPage: Int) -> CustomWebView?
    {
        return self.myPageDataArray[indexPage] as? CustomWebView
    }
    func browserWith(pageScrollView: HGPageScrollView)
    {
        if(pageScrollView.viewMode == HGPageScrollViewModePage)
        {
            pageScrollView.deselectPage(animated: true)
        }
        else
        {
            pageScrollView.selectPage(at: pageScrollView.indexForSelectedPage(), animated: true)
        }
    }
    func addNewLastPageTo(pageScrollView: HGPageScrollView)
    {
        self.addNewPageTo(pageScrollView: pageScrollView, atIndexSet: NSIndexSet(index: self.myPageDataArray.count))
    
        
    }
    func addNewPageTo(pageScrollView: HGPageScrollView, atIndexSet indexSet: NSIndexSet)
    {
        addNewElemnet(index: indexSet)
        pageScrollView.insertPages(at: indexSet as IndexSet!, animated: true)
    }
    func addNewElemnet(index: NSIndexSet)
    {
        let webview = CustomWebView()
        self.myPageDataArray.insert(webview, at: myPageDataArray.count)
    }
    func removePageFrom(pageScrollView: HGPageScrollView, atIndexSet indexSet: NSIndexSet)
    {
        self.myPageDataArray.removeObjects(at: indexSet as IndexSet)
        pageScrollView.deletePages(at: indexSet as IndexSet!, animated: true)
        
        if (self.myPageDataArray.count == 1)
        {
            //Het phan tu
        }
    }
    func reloadFrom(pageScrollView: HGPageScrollView, atIndexSet indexSet: NSIndexSet)
    {
        pageScrollView.reloadPages(at: indexSet as IndexSet!)
    }
    
    //bookmark
    func savePageToBookmark(indexPage: Int)
    {
        let webView = getPage(indexPage: indexPage)
        self.manageDataBase.saveName(title:(webView?.webView.title)!, url: (webView?.webView.url?.absoluteString)!)
    }
}
