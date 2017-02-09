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
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressCount: UILabel!
    var searchResults = [Track]()
    var downloadView: DownloadView!
    var webView: WKWebView!
    var longPress = false
    let mainJavascript = "function MyAppGetHTMLElementsAtPoint(x,y) { var tags = \",\"; var e = document.elementFromPoint(x,y); while (e) { if (e.tagName) { tags += e.tagName + ','; } e = e.parentNode; } return tags; } function MyAppGetLinkSRCAtPoint(x,y) { var tags = \"\"; var e = document.elementFromPoint(x,y); while (e) { if (e.src) { tags += e.src; break; } e = e.parentNode; } return tags; }  function MyAppGetLinkHREFAtPoint(x,y) { var tags = \"\"; var e = document.elementFromPoint(x,y); while (e) { if (e.href) { tags += e.href; break; } e = e.parentNode; } return tags; }"
    
    override func viewDidLoad() {
        progressBar.setProgress(0.0, animated: true)  //set progressBar to 0 at start
        
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizerAction(sender:)))
        longPressRecognizer.delegate = self
        
        let source = "var style = document.createElement('style'); style.type = 'text/css'; style.innerText = '*:not(input):not(textarea) { -webkit-touch-callout: none; }'; var head = document.getElementsByTagName('head')[0]; head.appendChild(style);"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height), configuration: config)
        
        let url = URL (string: "http://www.nhaccuatui.com/")
        let requestObj = URLRequest(url: url!)

        
        
        self.webView.load(requestObj)
        webView.navigationDelegate = self
        
        self.webView.scrollView.addGestureRecognizer(longPressRecognizer)
        self.view.addSubview(self.webView)

    }
    
    func longPressRecognizerAction(sender: UILongPressGestureRecognizer) {
        longPress = true
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
                self.downloadFileWithURL(urlString: result as! String)
//                data?.write(toFile: "/Users/nguyenvantu/Desktop/TrekHaGiang.jpg", atomically: true)
            })

            
//            print("tags: \(tags)\nhref: \(href)\nsrc: \(src)")
            // handle the results, for example with an UIDocumentInteractionController
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "downloadView")
        {
            if let downloadView = segue.destination as? DownloadView
            {
                downloadView.searchResults = self.searchResults
            }
        }
    }
    func downloadFileWithURL(urlString: String)
    {
        let track = Track(name: urlString, artist: nil, previewUrl: urlString)
        searchResults.append(track)
//        let url = URL(string:urlString)!
//        let req = NSMutableURLRequest(url:url)
//        let configS = URLSessionConfiguration.default
//        let session = URLSession(configuration: configS, delegate: self, delegateQueue: OperationQueue.main)
//        
//        let task : URLSessionDownloadTask = session.downloadTask(with: req as URLRequest)
//        task.resume()
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
extension ViewController: URLSessionDownloadDelegate
{
    
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)" as AnyObject)
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
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
