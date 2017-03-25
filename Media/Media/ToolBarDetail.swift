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
    @IBOutlet weak var btn_Previous: UIButton!
    
    @IBOutlet weak var btn_Forward: UIButton!
    
    @IBOutlet weak var btn_Bookmark: UIButton!
    
    @IBOutlet weak var btn_Browser: UIButton!
    @IBOutlet weak var btn_Download: UIButton!
    @IBOutlet weak var btn_Zoom: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }
    override func zoomAction(isZoomIn: Bool)
    {
        if(isZoomIn == true)
        {
            self.btn_Zoom.setImage(UIImage(named:"ZoonInIcon"), for: .normal)
        }
        else
        {
            self.btn_Zoom.setImage(UIImage(named:"ZoomOutIcon"), for: .normal)
        }
    }
    override func resizeButtons()
    {
        btn_Previous.alignContentVerticallyByCenter(offset: 5)
        btn_Forward.alignContentVerticallyByCenter(offset: 5)
        btn_Bookmark.alignContentVerticallyByCenter(offset: 5)
        btn_Browser.alignContentVerticallyByCenter(offset: 5)
        btn_Download.alignContentVerticallyByCenter(offset: 5)
        btn_Zoom.alignContentVerticallyByCenter(offset: 5)

    }
    func setup() {
        isToolBarNewPage = false
        view = loadViewFromNib()
        self.view.frame = self.frame
        self.addSubview(view)
    }
    func loadViewFromNib() -> UIView {
        let subView = Bundle.main.loadNibNamed("ToolBarDetail", owner: self, options: nil)?[0]
        return subView as! UIView
    }
    @IBAction func actionPrevious(_ sender: Any) {
        self.delegate?.showPreviousPage()
    }
    @IBAction func actionForward(_ sender: Any) {
        self.delegate?.showForwardPage()
    }
    @IBAction func actionBookmark(_ sender: Any) {
        self.delegate?.actionBookMark()
    }
    @IBAction func actionBrowser(_ sender: Any) {
        self.delegate?.showBrowser()
    }
    @IBAction func actionDownload(_ sender: Any) {
        self.delegate?.showDownloadView()
    }
    
    @IBAction func actionZoom(_ sender: Any) {
        self.delegate?.zoom()
    }
   
}
