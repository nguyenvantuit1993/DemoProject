//
//  ViewController.swift
//  TouchToDownload
//
//  Created by Nguyen Van Tu on 2/7/17.
//  Copyright © 2017 Nguyen Van Tu. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var longPress = false
    let mainJavascript = "function MyAppGetHTMLElementsAtPoint(x,y) { var tags = \",\"; var e = document.elementFromPoint(x,y); while (e) { if (e.tagName) { tags += e.tagName + ','; } e = e.parentNode; } return tags; } function MyAppGetLinkSRCAtPoint(x,y) { var tags = \"\"; var e = document.elementFromPoint(x,y); while (e) { if (e.src) { tags += e.src; break; } e = e.parentNode; } return tags; }  function MyAppGetLinkHREFAtPoint(x,y) { var tags = \"\"; var e = document.elementFromPoint(x,y); while (e) { if (e.href) { tags += e.href; break; } e = e.parentNode; } return tags; }"
    
    override func viewDidLoad() {
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizerAction(sender:)))
        longPressRecognizer.delegate = self
        
        let source = "var style = document.createElement('style'); style.type = 'text/css'; style.innerText = '*:not(input):not(textarea) { -webkit-touch-callout: none; }'; var head = document.getElementsByTagName('head')[0]; head.appendChild(style);"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        self.webView = WKWebView(frame: self.view.frame, configuration: config)
        
        let url = URL (string: "https://www.onlinevideoconverter.com/success?id=i8e4e4f5c2c2e4f5b1")
        let requestObj = URLRequest(url: url!)

        
        self.webView.evaluate(script: mainJavascript, completion: {(result, error) in
            print(result)
        })
        self.webView.load(requestObj)
        self.webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';", completionHandler: nil)
        webView.navigationDelegate = self
        
        self.webView.scrollView.addGestureRecognizer(longPressRecognizer)
        self.view.addSubview(self.webView)

    }
    
    func longPressRecognizerAction(sender: UILongPressGestureRecognizer) {
        longPress = true
        if sender.state == UIGestureRecognizerState.began {
            
            let tapPostion = sender.location(in: self.webView)
            self.webView.evaluate(script: "MyAppGetHTMLElementsAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
               print(result)
            })
            self.webView.evaluate(script: "MyAppGetLinkHREFAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
//                self.present(self.actionMenu(), animated: true, completion: nil)
                self.presentNextWebView()
                print(result)
            })
            self.webView.evaluate(script: "MyAppGetLinkSRCAtPoint(\(tapPostion.x),\(tapPostion.y));", completion: {(result, error) in
                print(result)
            })

            
//            print("tags: \(tags)\nhref: \(href)\nsrc: \(src)")
            // handle the results, for example with an UIDocumentInteractionController
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated{
//            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
            
        }else{
            
            decisionHandler(.allow)
            
        }
    }

    // Without this function, the customLongPressRecognizer would be replaced by the original UIWebView LongPressRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //Build action sheet
    func actionMenu() -> UIAlertController {
    
        let alertController = UIAlertController(title: "Title", message: "Some message.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        let someAction = UIAlertAction(title: "Some action", style: .default) { (action) in
            //do something, call a function etc, when this action is selected
        }
        alertController.addAction(someAction)
        
        return alertController
    }

}
extension WKWebView {
    func evaluate(script: String, completion: ((Any?, Error?) -> Void)? = nil) {
        var finished = false
        
        evaluateJavaScript(script) { (result, error) in
            if error == nil {
                if result != nil {
                    completion?(result, nil)
                }
            } else {
                completion?(nil, error)
            }
            finished = true
        }
        
        while !finished {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)
        }
    }
}
