//
//  ToolBarDetail.swift
//  CustomWebView
//
//  Created by Tuuu on 2/10/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class ToolBarDetail: BaseToolBar {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var btn_Previous: UIBarButtonItem!
    
    @IBOutlet weak var btn_Forward: UIBarButtonItem!
    
    @IBOutlet weak var btn_Bookmark: UIBarButtonItem!
    
    @IBOutlet weak var btn_Browser: UIBarButtonItem!
    @IBOutlet weak var btn_Download: UIBarButtonItem!
    @IBOutlet weak var btn_Zoom: UIBarButtonItem!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }
    func setup() {
        isToolBarNewPage = false
        view = loadViewFromNib()
        self.addSubview(view)
    }
    func loadViewFromNib() -> UIView {
        let subView = Bundle.main.loadNibNamed("ToolBarDetail", owner: self, options: nil)?[0]
        return subView as! UIView
    }
    @IBAction func actionPrevious(_ sender: Any) {
    }
    @IBAction func actionForward(_ sender: Any) {
    }
    @IBAction func actionBookmark(_ sender: Any) {
    }
    @IBAction func actionBrowser(_ sender: Any) {
        self.delegate?.showBrowser()
    }
    @IBAction func actionDownload(_ sender: Any) {
    }
    @IBAction func actionZoom(_ sender: Any) {
    }

    
    
}
