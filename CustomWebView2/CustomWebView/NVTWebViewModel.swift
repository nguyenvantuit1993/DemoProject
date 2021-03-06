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
    override init() {
        self.myPageDataArray = NSMutableArray()
        let webview = CustomWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
        let webview2 = CustomWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
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
    func actionBookMark()
    {
        
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
}

