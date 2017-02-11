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
    var webView: WKWebView!
    let mainJavascript = "function MyAppGetHTMLElementsAtPoint(x,y) { var tags = \",\"; var e = document.elementFromPoint(x,y); while (e) { if (e.tagName) { tags += e.tagName + ','; } e = e.parentNode; } return tags; } function MyAppGetLinkSRCAtPoint(x,y) { var tags = \"\"; var e = document.elementFromPoint(x,y); while (e) { if (e.src) { tags += e.src; break; } e = e.parentNode; } return tags; }  function MyAppGetLinkHREFAtPoint(x,y) { var tags = \"\"; var e = document.elementFromPoint(x,y); while (e) { if (e.href) { tags += e.href; break; } e = e.parentNode; } return tags; }"
    let disableCallBackSource = "var style = document.createElement('style'); style.type = 'text/css'; style.innerText = '*:not(input):not(textarea) { -webkit-touch-callout: none; }'; var head = document.getElementsByTagName('head')[0]; head.appendChild(style);"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addWebView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addWebView()
    }
    func addWebView()
    {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizerAction(sender:)))
        longPressRecognizer.delegate = self
        
        let script = WKUserScript(source: disableCallBackSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), configuration: config)
        
        webView.navigationDelegate = self
        
        self.webView.scrollView.addGestureRecognizer(longPressRecognizer)
        self.addSubview(self.webView)
    }
    func loadRequest()
    {
        let url = URL (string: "http://www.nhaccuatui.com/")
        let requestObj = URLRequest(url: url!)
        
        self.webView.load(requestObj)
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
