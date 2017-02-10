//
//  NVTWebView.swift
//  CustomWebView
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class NVTWebView: UIViewController{
    
    var toolBar: BaseToolBar!
    var toolBarDetail: ToolBarDetail!
    var myPageScrollView: MyPagedFlowView!
    var webviewModel: NVTWebViewModel!
    let pageId = "pageId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let sizeView = self.view.frame.size
        let centerView = self.view.center
        let frameToShow = CGRect(x: centerView.x - sizeView.width/2, y: centerView.y - sizeView.height/2, width: sizeView.width/2, height: sizeView.height/2)
        webviewModel = NVTWebViewModel(frame:frameToShow)
        addToolBar()
        addPageScrollView()
    }
    func addToolBar()
    {
        if (self.toolBar == nil)
        {
            addToolBarNewPage()
        }
        else
        {
            self.toolBar.removeFromSuperview()
            if (self.toolBar.isToolBarNewPage == false)
            {
                addToolBarNewPage()
            }
            else
            {
                addToolBarDetail()
            }
        }
        self.toolBar.delegate = self
        self.view.addSubview(self.toolBar)
    }
    func addToolBarNewPage()
    {
        self.toolBar = ToolBarNewPage(frame: CGRect(x: 0, y: self.view.frame.size.height-40, width: self.view.frame.size.width, height: 40))
    }
    func addToolBarDetail()
    {
        self.toolBar = ToolBarDetail(frame: CGRect(x: 0, y: self.view.frame.size.height-40, width: self.view.frame.size.width, height: 40))
    }
    func addPageScrollView()
    {
        self.myPageScrollView = MyPagedFlowView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-40))
        self.myPageScrollView.scrollView.delegate = self
        self.myPageScrollView.scrollView.dataSource = self
        self.view.addSubview(myPageScrollView)
    }
    
    func layoutPageScrollView()
    {
        myPageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: myPageScrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -40)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
}
extension NVTWebView: ToolBarDelegate
{
    func addNewPage()
    {
        

    }

    func showCurrentPage()
    {
//        showPage(with: self.myPageScrollView, at: -1)
        addToolBar()
    }
    func showPreviousPage()
    {}
    func showForwardPage()
    {}
    func actionBookMark()
    {}
    func showBrowser()
    {
        showCurrentPage()
    }
    func showDownloadView()
    {}
    func zoom()
    {}
    func switchToolBar()
    {
        
    }
}
extension NVTWebView: PagedFlowViewDataSource
{
    func numberOfPages(in flowView: PagedFlowView!) -> Int {
        return webviewModel.myPageDataArray.count;
    }
    func flowView(_ flowView: PagedFlowView!, cellForPageAt index: Int) -> UIView! {
//        var currentView = flowView.dequeueReusableCell()
//        if(currentView == nil)
//        {
//            currentView = webviewModel.myPageDataArray[index]
//        }
        return webviewModel.myPageDataArray.object(at: index) as! UIView
        
    }
}
extension NVTWebView: PagedFlowViewDelegate
{
    func sizeForPage(in flowView: PagedFlowView!) -> CGSize {
        return CGSize(width: 200, height: 400)
    }
}

