//
//  ItemCell.swift
//  TouchToDownload
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Nguyen Van Tu. All rights reserved.
//

import UIKit

protocol TrackCellDelegate {
    func pauseTapped(_ cell: ItemCell)
    func resumeTapped(_ cell: ItemCell)
    func cancelTapped(_ cell: ItemCell)
    func downloadTapped(_ cell: ItemCell)
}

class ItemCell: UITableViewCell {
    
    var delegate: TrackCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBAction func pauseOrResumeTapped(_ sender: AnyObject) {
        if(pauseButton.titleLabel!.text == "Pause") {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadTapped(_ sender: AnyObject) {
        delegate?.downloadTapped(self)
    }
}
