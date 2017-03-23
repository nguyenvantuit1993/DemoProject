//
//  ToolBarNewPage.swift
//  Media
//
//  Created by Tuuu on 2/10/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//
protocol ToolBarDelegate {
    func addNewPage()
    func showCurrentPage()
    func showPreviousPage()
    func showForwardPage()
    func actionBookMark()
    func showBrowser()
    func showDownloadView()
    func zoom()
    func switchToolBar()
}
protocol CustomToolBar {
    var delegate: ToolBarDelegate?{get set}
    var isToolBarNewPage: Bool?{get set}
}
import UIKit


class ToolBarNewPage: BaseToolBar  {

    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var btn_NewPage: UIButton!
    
    @IBOutlet weak var btn_Done: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }
    func setup() {
        isToolBarNewPage = true
        view = loadViewFromNib()
        self.view.frame = self.frame
        self.addSubview(view)
    }
    func loadViewFromNib() -> UIView {
        let subView = Bundle.main.loadNibNamed("ToolBarNewPage", owner: self, options: nil)?[0]
        return subView as! UIView
    }
    @IBAction func actionAddNewPage(_ sender: Any) {
        self.delegate?.addNewPage()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        self.delegate?.showCurrentPage()
    }
    
}

class BaseToolBar:UIView, CustomToolBar
{
    var isToolBarNewPage: Bool?
    var delegate: ToolBarDelegate?
}
