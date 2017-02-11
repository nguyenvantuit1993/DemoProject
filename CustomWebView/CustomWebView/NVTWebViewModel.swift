//
//  NVTWebViewModel.swift
//  CustomWebView
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class NVTWebViewModel{
    var myPageDataArray: NSMutableArray!
    var indexesToDelete, indexesToInsert, indexesToReload: NSMutableIndexSet!
    init(frame: CGRect) {
        self.myPageDataArray = NSMutableArray()
        let webview = CustomWebView(frame: frame)
        let webview2 = CustomWebView(frame: frame)
        self.myPageDataArray.add(webview)
        self.myPageDataArray.add(webview2)
    }
    func setupDataToView(currentView: CustomWebView) -> CustomWebView
    {
        return currentView
    }
}
