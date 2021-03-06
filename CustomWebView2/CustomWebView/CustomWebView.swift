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

class CustomWebView: HGPageView, UIGestureRecognizerDelegate, WKNavigationDelegate {
    @IBOutlet weak var view: UIView!
    var webView: WKWebView!
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
        
        let script = WKUserScript(source: disableCallBackSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        
        self.webView = WKWebView(frame: self.frame, configuration: config)
        
        webView.navigationDelegate = self
        
        self.webView.scrollView.addGestureRecognizer(longPressRecognizer)
        self.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
   
    }
    func loadRequest()
    {
        let url = URL (string: "http://www.google.com/")
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
//            self.webView.reload()
        } else {
            print("Can't go foward")
        }
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
                //                let data = NSData(contentsOf: URL(string: result! as! String)!)
                print(result)
//                self.downloadFileWithURL(urlString: result as! String)
                //                data?.write(toFile: "/Users/nguyenvantu/Desktop/TrekHaGiang.jpg", atomically: true)
            })
        }
    }
}
