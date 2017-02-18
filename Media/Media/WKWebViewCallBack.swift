//
//  WKWebViewCallBack.swift
//  CustomWebView
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    func evaluate(script: String, completion: ((Any?, Error?) -> Void)? = nil){
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
    func evaluateReturn(script: String) -> String{
        var finished = false
        var resultString: String!
        evaluateJavaScript(script) { (result, error) in
            if error == nil {
                if result != nil {
                    resultString = result as? String
                }
            } else {
                print(error.debugDescription)
            }
            finished = true
        }
        
        while !finished {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)
        }
        return resultString
    }
}
