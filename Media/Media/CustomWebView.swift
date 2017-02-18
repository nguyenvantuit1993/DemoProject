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
    func didShowAler(title: String)
}

class CustomWebView: HGPageView {
    var delegateCustomWeb: CustomWebViewDelegate!
    @IBOutlet weak var view: UIView!
    var customWebViewModel = CustomWebViewModel()
    var webView: WKWebView!
    var isPosibleLoad: Bool!
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
    }
    func loadViewFromNib() -> UIView {
        let subView = Bundle.main.loadNibNamed("CustomWebView", owner: self, options: nil)?[0]
        return subView as! UIView
    }
    
    func addWebView()
    {
        self.layoutIfNeeded()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizerAction(sender:)))
        longPressRecognizer.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerAction(sender:)))
        tapGesture.delegate = self
        
        let script = WKUserScript(source: disableCallBackSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        
        self.webView = WKWebView(frame: self.frame, configuration: config)
        
        webView.navigationDelegate = self
        self.webView.scrollView.addGestureRecognizer(longPressRecognizer)
        self.webView.scrollView.addGestureRecognizer(tapGesture)
        self.addSubview(self.webView)
        addLayoutWebView()
        
        
    }
    func addLayoutWebView()
    {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    func loadRequest(url: String, isPosibleLoad: Bool)
    {
        self.isPosibleLoad = isPosibleLoad
        let url = URL (string: url)
        let requestObj = URLRequest(url: url!)
        
        self.webView.load(requestObj)
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
        self.webView.evaluate(script: mainJavascript, completion: {(result, error) in
            print(result)
        })
        if sender.state == UIGestureRecognizerState.began {
            
            let tapPostion = sender.location(in: self.webView)
            self.webView.evaluate(script: "MyAppGetHTMLElementsAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
                print(result)
            })
            self.webView.evaluate(script: "MyAppGetLinkHREFAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
                //                self.present(self.actionMenu(), animated: true, completion: nil)
                //                self.presentNextWebView()
                print(result)
            })
            self.webView.evaluate(script: "MyAppGetLinkSRCAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
                self.customWebViewModel.addURL(urlString: result as! String)
                print(result)
            })
        }
    }
    func tapRecognizerAction(sender: UITapGestureRecognizer) {
        self.webView.evaluate(script: mainJavascript)
        
        let tapPostion = sender.location(in: self.webView)
        self.webView.evaluate(script: "MyAppGetHTMLElementsAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
            print(result)
        })
        self.webView.evaluate(script: "MyAppGetLinkHREFAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
            //                self.present(self.actionMenu(), animated: true, completion: nil)
            //                self.presentNextWebView()
            print(result)
        })
        self.webView.evaluate(script: "MyAppGetLinkSRCAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
            self.customWebViewModel.addURL(urlString: result as! String)
            print(result)
        })
        
    }
}
extension CustomWebView: WKNavigationDelegate
{
    //    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    //    }
    //        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    //            if(isPosibleLoad == false && navigationAction.navigationType == .linkActivated)
    //            {
    //                //            decisionHandler(.cancel)
    //                self.showActionSheet(title: (webView.url?.relativeString)!)
    //            }
    //            isPosibleLoad = false
    //
    //            decisionHandler(.allow)
    //        }
    
}
extension CustomWebView
{
    func showActionSheet(title: String)
    {
        self.delegateCustomWeb.didShowAler(title: title)
    }
}
extension CustomWebView: UIGestureRecognizerDelegate
{
    // Without this function, the customLongPressRecognizer would be replaced by the original UIWebView LongPressRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
