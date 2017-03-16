//
//  CustomWebView.swift
//  CustomWebView
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol CustomWebViewDelegate {
    func didShowAler(tags:String, href:String, src:String)
}

class CustomWebView: HGPageView {
    var delegateCustomWeb: CustomWebViewDelegate!
    @IBOutlet weak var view: UIView!
    internal var lastContentOffset: CGFloat = 0
    internal var buttonRefresh: UIButton!
    private let widthGoogleSearch:CGFloat = 100
    private let heightSearchField:CGFloat = 40
    private let margin:CGFloat = 10
    private let widthRightButton:CGFloat = 30
    var searchBar: UISearchBar!
    var progBar: UIProgressView!
    var title: UILabel!
    var customWebViewModel = CustomWebViewModel()
    var txt_SearchText: UITextField!
    var isShowSearchText = false
    var webView: WKWebView!
    var isPosibleLoad = false
    let mainJavascript = "function MyAppGetHTMLElementsAtPoint(x,y) { var tags = \",\"; var e = document.elementFromPoint(x,y); while (e) { if (e.tagName) { tags += e.tagName + ','; } e = e.parentNode; } return tags; } function MyAppGetLinkSRCAtPoint(x,y) { var tags = \"\"; var e = document.elementFromPoint(x,y); while (e) { if (e.src) { tags += e.src; break; } e = e.parentNode; } return tags; }  function MyAppGetLinkHREFAtPoint(x,y) { var tags = \"\"; var e = document.elementFromPoint(x,y); while (e) { if (e.href) { tags += e.href; break; } e = e.parentNode; } return tags; }"
    let disableCallBackSource = "var style = document.createElement('style'); style.type = 'text/css'; style.innerText = '*:not(input):not(textarea) { -webkit-touch-callout: none; }'; var head = document.getElementsByTagName('head')[0]; head.appendChild(style);"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    func setup() {
        addWebView()
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    func loadViewFromNib() -> UIView {
        let subView = Bundle.main.loadNibNamed("CustomWebView", owner: self, options: nil)?[0]
        return subView as! UIView
    }
    func showSearchText()
    {
        if isShowSearchText == false {
            self.searchBar.showsBookmarkButton = false
            self.searchBar.showsCancelButton = true
            self.isShowSearchText = true
            
        } else {
            self.searchBar.resignFirstResponder()
            self.searchBar.showsCancelButton = false
            self.searchBar.showsBookmarkButton = true
            self.isShowSearchText = false
        }
    }
    
    func hiddenSearchBar(hidden: Bool)
    {
        if(hidden == true)
        {
            self.searchBar.delegate = nil
            self.searchBar.removeFromSuperview()
            self.title.removeFromSuperview()
        }
        else
        {
            addHeaderToWebView()
        }
        updateWebViewScrollViewContentInset(isHidden: hidden)
    }
    func addHeaderToWebView(){
        title = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: self.heightSearchField))
        title.backgroundColor = UIColor.darkGray
        title.textColor = UIColor.white
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        self.addSubview(title)
        
        // the constraints
        var topConstraint = NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20)
        var leftConstraint = NSLayoutConstraint(item: title, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        var rightConstraint = NSLayoutConstraint(item: title, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        var heightConstraint = NSLayoutConstraint(item: self.title, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.heightSearchField*0.8)
        // we add the constraints
        self.addConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        // We load the headerView from a Nib
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: self.heightSearchField))
        searchBar.barTintColor = UIColor.darkGray
        searchBar.setImage(UIImage(named: "RefreshButton"), for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        self.addSubview(searchBar)
        
        // the constraints
        topConstraint = NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20)
        leftConstraint = NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        rightConstraint = NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        heightConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.heightSearchField)
        // we add the constraints
        self.addConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        progBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: self.heightSearchField))
        progBar.translatesAutoresizingMaskIntoConstraints = false
        progBar.progress = 0
        progBar.alpha = 0
//        progBar.tintColor = UIColor.blue
        
        self.addSubview(progBar)
        
        // the constraints
        topConstraint = NSLayoutConstraint(item: progBar, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom, multiplier: 1, constant: 0)
        leftConstraint = NSLayoutConstraint(item: progBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        rightConstraint = NSLayoutConstraint(item: progBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        heightConstraint = NSLayoutConstraint(item: progBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3)
        // we add the constraints
        self.addConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" && self.progBar != nil
        {
            
            self.progBar.alpha = 1.0
            self.progBar.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if(self.webView.estimatedProgress >= 1.0)
            {
                self.searchBar.setImage(UIImage(named: "RefreshButton"), for: .bookmark, state: .normal)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: { 
                    self.progBar.alpha = 0
                }, completion: { (finished) in
                    self.progBar.progress = 0
                })
            }
        }
    }
    func refreshButtonPressed()
    {
        if(!self.webView.isLoading)
        {
            self.webView.reload()
        }
        else
        {
            self.webView.stopLoading()
        }
    }
    func updateWebViewScrollViewContentInset(isHidden: Bool){
        let valueToScroll = isHidden == true ? 0 : (self.heightSearchField + 20)
        self.webView.scrollView.contentInset = UIEdgeInsets(top: valueToScroll, left: 0, bottom: 0, right: 0)
        self.webView.scrollView.contentOffset = CGPoint(x: 0, y: -valueToScroll)
    }
    func addWebView()
    {
        self.layoutIfNeeded()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizerAction(sender:)))
        longPressRecognizer.delegate = self
        
        
        let script = WKUserScript(source: disableCallBackSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        self.webView = WKWebView(frame: self.frame, configuration: config)
        webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        self.webView.scrollView.addGestureRecognizer(longPressRecognizer)
        self.addSubview(self.webView)
        addLayoutWebView()
        
        
    }
    func addLayoutWebView()
    {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let topConstraintWebView = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([horizontalConstraint, topConstraintWebView, widthConstraint, heightConstraint])
    }
    func loadRequest(url: String, isPosibleLoad: Bool)
    {
        self.isPosibleLoad = isPosibleLoad
        let url = URL (string: url)
        if(url != nil)
        {
            let requestObj = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 1.0)
            self.webView.load(requestObj)
        }
    }
    func runScriptString(script: String)
    {
        if(script != "")
        {
            self.webView.evaluate(script: "window.location = '/';")
        }
        
    }
    func goBackPage()
    {
        if self.webView.canGoBack {
            print("Can go back")
            self.webView.goBack()
            //            self.webView.reload()
        } else {
            print("Can't go back")
        }
    }
    func goForwardPage()
    {
        if self.webView.canGoForward {
            self.webView.goForward()
        } else {
            print("Can't go foward")
        }
    }
    func getURLs() -> [Track]
    {
        return self.customWebViewModel.urls
    }
    func longPressRecognizerAction(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            let tapPostion = sender.location(in: self.webView)
            self.getLink(tapPostion: tapPostion)
        }
    }
    func getLink(tapPostion: CGPoint)
    {
        isPosibleLoad = false
        self.webView.evaluate(script: mainJavascript)
        let tags = self.webView.evaluateReturn(script: "MyAppGetHTMLElementsAtPoint(\(tapPostion.x),\(tapPostion.y));")
        let tagsHREF = self.webView.evaluateReturn(script: "MyAppGetLinkHREFAtPoint(\(tapPostion.x),\(tapPostion.y));")
        let tagsSRC = self.webView.evaluateReturn(script: "MyAppGetLinkSRCAtPoint(\(tapPostion.x),\(tapPostion.y));")
        self.showActionSheet(tags: tags, href: tagsHREF, src: tagsSRC)
        
    }
    func tapRecognizerAction(sender: UITapGestureRecognizer) {
//        let tapPostion = sender.location(in: self.webView)
//        self.getLink(tapPostion: tapPostion)
    }
}

extension CustomWebView: WKNavigationDelegate
{
    //    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    //    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //        print(navigationAction)
        if(isPosibleLoad == false)
        {
            decisionHandler(.cancel)
        }
        else
        {
            decisionHandler(.allow)
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.searchBar?.setImage(UIImage(named: "CloseButton"), for: .bookmark, state: .normal)
    }
    
}
extension CustomWebView: UISearchBarDelegate
{
    func loadRequestFromString(string: String)
    {
        let validString = string.lowercased().validLink()
        var link = validString.link
        if(validString.isValid == false)
        {
            link = "\(kGoogleSearchLink)\(link)"
        }
        self.loadRequest(url: link, isPosibleLoad: true)
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.refreshButtonPressed()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchText()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchText()
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showSearchText()
        loadRequestFromString(string: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showSearchText()
    }
}
extension CustomWebView
{
    func showActionSheet(tags:String, href:String, src:String)
    {
        self.delegateCustomWeb!.didShowAler(tags:tags, href:href, src:src)
    }
}
extension CustomWebView: UIGestureRecognizerDelegate
{
    // Without this function, the customLongPressRecognizer would be replaced by the original UIWebView LongPressRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension CustomWebView: UIScrollViewDelegate
{
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //
    //        if (scrollView.contentOffset.y > 0)
    //        {
    ////            self.searchBar?.isHidden = true
    //        }
    //        else
    //        {
    //            self.searchBar?.isHidden = false
    //        }
    //
    //    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (self.lastContentOffset < scrollView.contentOffset.y)
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar?.alpha = 0
                self.title.text = self.webView.title
            })
            
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar?.alpha = 1
            })
            
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
