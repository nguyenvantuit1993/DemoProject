//
//  DisableActionSheetWKWebView.swift
//  TouchToDownload
//
//  Created by Nguyen Van Tu on 2/8/17.
//  Copyright © 2017 Nguyen Van Tu. All rights reserved.
//

import Foundation
//override func viewDidLoad() {
//    
//    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizerAction(sender:)))
//    longPressRecognizer.delegate = self
//    
//    let source = "var style = document.createElement('style'); style.type = 'text/css'; style.innerText = '*:not(input):not(textarea) { -webkit-user-select: none; -webkit-touch-callout: none; }'; var head = document.getElementsByTagName('head')[0]; head.appendChild(style);"
//    let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//    let userContentController = WKUserContentController()
//    userContentController.addUserScript(script)
//    let config = WKWebViewConfiguration()
//    config.userContentController = userContentController
//    self.webView = WKWebView(frame: self.view.frame, configuration: config)
//    
//    let url = URL (string: "http://kenh14.vn/trang-tuyet-nguyet-thuc-va-sao-choi-tat-ca-se-cung-xuat-hien-vao-cuoi-tuan-nay-20170207083518895.chn")
//    let requestObj = URLRequest(url: url!)
//    
//    
//    self.webView.evaluate(script: mainJavascript, completion: {(result, error) in
//        print(result)
//    })
//    self.webView.load(requestObj)
//    self.webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';", completionHandler: nil)
//    webView.navigationDelegate = self
//    
//    self.webView.scrollView.addGestureRecognizer(longPressRecognizer)
//    self.view.addSubview(self.webView)
//    
//}
