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
}
import UIKit


class ToolBarNewPage: UIView {
    var delegate: ToolBarDelegate?
    @IBOutlet weak var btn_NewPage: UIBarButtonItem!
    
    @IBOutlet weak var btn_Done: UIBarButtonItem!
    
    @IBAction func actionAddNewPage(_ sender: Any) {
        self.delegate?.addNewPage()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        self.delegate?.showCurrentPage()
    }
}
